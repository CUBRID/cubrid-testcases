--+ holdcas on;
-- workspace#338 (map #312, collation axis): the #322 probes A-F keep develop's answers
-- A2 coalesce(enum_col, ?) is workspace#326 and stays out of this case
drop table if exists dcg_te;
create table dcg_te (e enum('a','b') collate utf8_en_ci, s varchar(10) collate utf8_en_cs);
insert into dcg_te values ('a','x');

-- A. ENUM sibling with a literal
select coalesce(e, 'x'), collation(coalesce(e, 'x')), typeof(coalesce(e, 'x')) from dcg_te;
select nullif(e, 'x'), typeof(nullif(e, 'x')), collation(nullif(e, 'x')) from dcg_te;
select case when 1=1 then e else 'x' end, typeof(case when 1=1 then e else 'x' end), collation(case when 1=1 then e else 'x' end) from dcg_te;
select e + 'x', typeof(e + 'x'), collation(e + 'x') from dcg_te;
select coalesce(e, s), typeof(coalesce(e, s)), collation(coalesce(e, s)) from dcg_te;

-- B. group_concat over NULL and over string binds (D2)
select group_concat(NULL), typeof(group_concat(NULL)), collation(group_concat(NULL)) from db_root;
select group_concat(s), collation(group_concat(s)) from dcg_te where 1=0;
prepare dcg_pb from 'select group_concat(?), collation(group_concat(?)) from db_root';
execute dcg_pb using NULL, NULL;
execute dcg_pb using 'a', 'a';
deallocate prepare dcg_pb;

-- C. SET NAMES after PREPARE
set names utf8 collate utf8_en_ci;
prepare dcg_pc1 from 'select ? = ?, collation(?)';
prepare dcg_pc2 from 'select ''a'' = ?, collation(''a''), collation(?)';
execute dcg_pc1 using 'a', 'A', 'a';
execute dcg_pc2 using 'A', 'A';
set names utf8 collate utf8_en_cs;
execute dcg_pc1 using 'a', 'A', 'a';
execute dcg_pc2 using 'A', 'A';
prepare dcg_pc3 from 'select ? = ?, collation(?)';
execute dcg_pc3 using 'a', 'A', 'a';
deallocate prepare dcg_pc1;
deallocate prepare dcg_pc2;
deallocate prepare dcg_pc3;
set names utf8;

-- D. ALTER ... COLLATE after PREPARE
drop table if exists dcg_tl;
create table dcg_tl (s varchar(10) collate utf8_en_cs);
insert into dcg_tl values ('Ab');
prepare dcg_pd from 'select s, collation(s) from dcg_tl where s like ?';
execute dcg_pd using 'a%';
alter table dcg_tl modify s varchar(10) collate utf8_en_ci;
execute dcg_pd using 'a%';
deallocate prepare dcg_pd;

-- E. multi-row VALUES with mixed-charset binds
prepare dcg_pe from 'select * from (values (?), (?)) as v(c)';
execute dcg_pe using _utf8'a', _utf8'b';
execute dcg_pe using _utf8'a', _euckr'b';
deallocate prepare dcg_pe;

-- F. environment
select collation('a'), charset('a');

drop table dcg_te;
drop table dcg_tl;
set names utf8;
--+ holdcas off;
