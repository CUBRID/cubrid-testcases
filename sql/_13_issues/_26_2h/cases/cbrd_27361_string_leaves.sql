/**
 *  This test case verifies CBRD-27361: an aggregate over one heap scan takes its rows a page at a time (the
 *  page batch), and the string predicates the batch evaluates on its own leaves must give the row path's
 *  answers: LIKE with '_', a backslash (no ESCAPE, so a literal), '%', a multibyte character, trailing
 *  spaces, NULL, NOT, AND/OR, "=", "<>" and IN under utf8_bin, utf8_en_ci, utf8_ko_cs, iso88591_bin and
 *  binary, with the CHAR padding, and SUBSTRING ... IN with a start and a length at and past the end.
 *
 *  Coverage:
 *    Case 1: LIKE on VARCHAR utf8_bin
 *    Case 2: LIKE on CHAR utf8_bin, padded to 10
 *    Case 3: LIKE under utf8_en_ci, utf8_ko_cs, iso88591_bin, binary
 *    Case 4: "=", "<>", IN: trailing spaces and the CHAR padding under each collation
 *    Case 5: SUBSTRING ... IN at and past the string end, multibyte
 */

drop table if exists t_str;
create table t_str (id int, vc varchar(40) collate utf8_bin, c10 char(10) collate utf8_bin, vci varchar(40) collate utf8_en_ci, ci char(10) collate utf8_en_ci, vk varchar(40) collate utf8_ko_cs, vi varchar(40) collate iso88591_bin, ci8 char(10) collate iso88591_bin, vb varchar(40) collate binary, cb char(10) collate binary);
insert into t_str
  select n,
    case mod(n, 9) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then '한글abc' when 5 then null when 6 then 'ABC%x' when 7 then 'abc한' else 'v' || n end,
    case mod(n, 9) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then '한글abc' when 5 then null when 6 then 'ABC%x' when 7 then 'abc한' else 'v' || mod(n, 100) end,
    case mod(n, 9) when 0 then 'abc' when 1 then 'ABC ' when 2 then 'Ab_c' when 3 then 'ab\c' when 4 then '한글ABC' when 5 then null when 6 then 'abc%X' when 7 then 'abc한' else 'V' || n end,
    case mod(n, 9) when 0 then 'ABC' when 1 then 'abc ' when 2 then 'ab_C' when 3 then 'ab\c' when 4 then '한글abc' when 5 then null when 6 then 'ABC%x' when 7 then 'abc한' else 'v' || mod(n, 100) end,
    case mod(n, 9) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then '한글abc' when 5 then null when 6 then 'ABC%x' when 7 then 'abc한' else 'v' || n end,
    cast (case mod(n, 7) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then null when 5 then 'ABC%x' else 'v' || n end as varchar(40) charset iso88591),
    cast (case mod(n, 7) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then null when 5 then 'ABC%x' else 'v' || mod(n, 100) end as char(10) charset iso88591),
    cast (case mod(n, 7) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then null when 5 then 'ABC%x' else 'v' || n end as varchar(40) charset binary),
    cast (case mod(n, 7) when 0 then 'abc' when 1 then 'abc ' when 2 then 'ab_c' when 3 then 'ab\c' when 4 then null when 5 then 'ABC%x' else 'v' || mod(n, 100) end as char(10) charset binary)
  from (select level as n from db_root connect by level <= 5000) x;
insert into t_str select n + 5000, 'abc' || n, 'ab' || mod(n, 10), 'abc' || n, 'ab' || mod(n, 10), 'abc' || n, 'abc' || n, 'ab' || mod(n, 10), 'abc' || n, 'ab' || mod(n, 10) from (select level as n from db_root connect by level <= 5000) x;
select count(*) from t_str;

evaluate 'Case 1: LIKE on VARCHAR utf8_bin: ''_'', a backslash (no ESCAPE: a literal), ''%'', multibyte, trailing spaces, NULL, NOT';
select count(*) from t_str where vc like 'ab_c';
select count(*) from t_str where vc like 'ab\c';
select count(*) from t_str where vc like 'ab\_c';
select count(*) from t_str where vc like 'abc';
select count(*) from t_str where vc like 'abc ';
select count(*) from t_str where vc like 'abc%';
select count(*) from t_str where vc like '%c';
select count(*) from t_str where vc like '한글%';
select count(*) from t_str where vc like '%한';
select count(*) from t_str where vc like '_글abc';
select count(*) from t_str where vc not like 'abc%';
select count(*) from t_str where vc not like '%c';
select count(*) from t_str where vc like null;
select count(*) from t_str where vc like 'abc' or vc like '%_c';
select count(*) from t_str where vc like 'ab%' and vc not like '%c';
select count(*) from t_str where vc like 'abc' and c10 like '%c';
select count(*) from t_str where vc = 'abc' and c10 like '%b_';

evaluate 'Case 2: LIKE on CHAR utf8_bin (padded to 10): the pattern''s end lets the padding match';
select count(*) from t_str where c10 like 'abc';
select count(*) from t_str where c10 like 'abc ';
select count(*) from t_str where c10 like 'ab_c';
select count(*) from t_str where c10 like 'ab\c';
select count(*) from t_str where c10 like '%c';
select count(*) from t_str where c10 like '%한';
select count(*) from t_str where c10 not like 'ab%';

evaluate 'Case 3: LIKE under utf8_en_ci, utf8_ko_cs, iso88591_bin, binary';
select count(*) from t_str where vci like 'abc%';
select count(*) from t_str where ci like 'ab_c';
select count(*) from t_str where vk like 'ab_c';
select count(*) from t_str where vk like '%한';
select count(*) from t_str where vi like _iso88591'ab_c';
select count(*) from t_str where ci8 like _iso88591'abc';
select count(*) from t_str where ci8 like _iso88591'%c';
select count(*) from t_str where vb like _binary'ab_c';
select count(*) from t_str where vb like _binary'abc';
select count(*) from t_str where vb like _binary'abc ';
select count(*) from t_str where cb like _binary'abc';

evaluate 'Case 4: "=", "<>", IN: trailing spaces and the CHAR padding under each collation';
select count(*) from t_str where vc = 'abc';
select count(*) from t_str where vc = 'abc ';
select count(*) from t_str where vc <> 'abc';
select count(*) from t_str where c10 = 'abc';
select count(*) from t_str where c10 = 'abc ';
select count(*) from t_str where c10 = cast('abc' as char(10));
select count(*) from t_str where c10 = '한글abc';
select count(*) from t_str where vc in ('abc', 'ab_c', '한글abc');
select count(*) from t_str where vc in ('abc', null);
select count(*) from t_str where c10 in (cast('abc' as char(10)), cast('v1' as char(10)));
select count(*) from t_str where vci = 'ABC';
select count(*) from t_str where ci = 'abc';
select count(*) from t_str where vk = 'abc';
select count(*) from t_str where vk in ('한글abc', 'abc한');
select count(*) from t_str where vi = _iso88591'abc';
select count(*) from t_str where vi = _iso88591'abc ';
select count(*) from t_str where ci8 = _iso88591'abc';
select count(*) from t_str where vi in (_iso88591'abc', _iso88591'v10', _iso88591'ab_c');
select count(*) from t_str where vb = _binary'abc';
select count(*) from t_str where vb = _binary'abc ';
select count(*) from t_str where cb = _binary'abc';
select count(*) from t_str where cb = cast(_binary'abc' as char(10) charset binary);
select count(*) from t_str where vb in (_binary'abc', _binary'abc ', _binary'v10');

evaluate 'Case 5: SUBSTRING IN: start and length at and past the end, multibyte';
select count(*) from t_str where substring(vc, 1, 2) in ('ab', 'xy');
select count(*) from t_str where substring(vc, 4, 1) in (' ', 'c');
select count(*) from t_str where substring(vc, 4, 5) in (' ', 'c', '한');
select count(*) from t_str where substring(vc, 10, 1) in ('a', ' ');
select count(*) from t_str where substring(vc, 2, 100) in ('bc', 'bc ', '글abc');
select count(*) from t_str where substring(vc, 1, 1) in ('한', 'a');
select count(*) from t_str where substring(vc, 3, 3) in ('abc', 'c한');
select count(*) from t_str where substring(c10, 1, 3) in ('abc', 'v1 ');
select count(*) from t_str where substring(vi, 2, 2) in (cast('bc' as varchar(2) charset iso88591), cast('b_' as varchar(2) charset iso88591));
select count(*) from t_str where substring(vb, 1, 4) in (_binary'abc ', _binary'ab\c');

drop table t_str;
