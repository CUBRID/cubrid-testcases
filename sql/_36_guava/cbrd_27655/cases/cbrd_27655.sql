/*
 * CBRD-27655: REGEXP functions with a pattern that can match an empty string
 * ('a|', 'b*', '^', '$', ...) under regexp_engine=re2.
 *
 * REGEXP_COUNT and REGEXP_REPLACE never returned (the search position did not
 * move past an empty match), and REGEXP_INSTR / REGEXP_SUBSTR returned the same
 * empty match for every occurrence.
 * Every query here must return, and re2 must give the same result as cppstd.
 */
set system parameters 'regexp_engine=re2';

drop table if exists t_27655;
create table t_27655 (id int primary key, s varchar(100), p varchar(20));
insert into t_27655 values (1, 'abc', 'a|'), (2, 'abc', 'b*'), (3, 'abc', 'x?'), (4, 'abc', '^'),
  (5, 'abc', '$'), (6, '가나다', '나*'), (7, 'aaa', 'a*'), (8, 'abcb', 'b'), (9, 'abcabc', '[ac]');

-- REGEXP_COUNT with constants (the queries from the report)
select regexp_count('abc', 'a|'), regexp_count('abc', 'b*'), regexp_count('abc', '^'), regexp_count('abc', '$');
select regexp_count('abc', 'b*', 2), regexp_count('abc', 'a|', 3), regexp_count('AbA', 'a*', 1, 'i');

-- REGEXP_COUNT on columns (evaluated per row)
select id, regexp_count(s, p) from t_27655 order by id;

-- REGEXP_INSTR: each occurrence of 'b*' in 'abc' is at 1, 2, 3, 4 and there is no 5th
select regexp_instr('abc', 'b*', 1, 1), regexp_instr('abc', 'b*', 1, 2), regexp_instr('abc', 'b*', 1, 3),
  regexp_instr('abc', 'b*', 1, 4), regexp_instr('abc', 'b*', 1, 5), regexp_instr('abc', 'b*', 1, 2, 1);
select id, regexp_instr(s, p, 1, 2), regexp_instr(s, p, 1, 3) from t_27655 order by id;

-- REGEXP_SUBSTR
select regexp_substr('abc', 'b*', 1, 2), regexp_substr('abc', 'b*', 1, 3), regexp_substr('abc', 'b*', 1, 5),
  regexp_substr('가나다', '나*', 1, 2);
select id, regexp_substr(s, p, 1, 2) from t_27655 order by id;

-- REGEXP_REPLACE: replace all, from a position, and a single occurrence
select regexp_replace('abc', 'b*', 'X'), regexp_replace('abc', 'a|', 'X'), regexp_replace('abc', '^', '>'),
  regexp_replace('abc', '$', '<');
select regexp_replace('abc', 'b*', 'X', 2), regexp_replace('abc', 'b*', 'X', 1, 2), regexp_replace('AbA', 'a*', 'X', 1, 0, 'i');
select id, regexp_replace(s, p, '-') from t_27655 order by id;

-- a long string with an empty match at every position
select regexp_count(repeat('ab', 5000), 'x*'), length(regexp_replace(repeat('ab', 5000), 'b*', 'X'));

-- the same queries under cppstd must give the same results
set system parameters 'regexp_engine=cppstd';
select id, regexp_count(s, p), regexp_instr(s, p, 1, 2), regexp_instr(s, p, 1, 3), regexp_substr(s, p, 1, 2),
  regexp_replace(s, p, '-') from t_27655 order by id;
select regexp_count(repeat('ab', 5000), 'x*'), length(regexp_replace(repeat('ab', 5000), 'b*', 'X'));

set system parameters 'regexp_engine=re2';
select id, regexp_count(s, p), regexp_instr(s, p, 1, 2), regexp_instr(s, p, 1, 3), regexp_substr(s, p, 1, 2),
  regexp_replace(s, p, '-') from t_27655 order by id;

drop table t_27655;
set system parameters 'regexp_engine=default';
