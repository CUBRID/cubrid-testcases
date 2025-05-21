-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

-- NOT tests (constant folding)
select ('a' rlike 'a'), ('a' not rlike 'a');
select ('a' rlike binary 'a'), ('a' not rlike binary 'a');

-- NOT tests (prep statements)
prepare regex_st from 'select (? rlike ?), (? not rlike ?), (? rlike binary ?), (? not rlike binary ?)';
execute regex_st using 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a';
deallocate prepare regex_st;

-- NOT tests (table)
create table t(c char(10), s string);
insert into t values ('a', 'a');

select (c rlike s), (c not rlike s), (c rlike binary s), (c not rlike binary s) from t;
select (s rlike c), (s not rlike c), (s rlike binary c), (s not rlike binary c) from t;

select * from t where c rlike s;
select * from t where s rlike c;
select * from t where c not rlike s;
select * from t where s not rlike c;

drop table t;

set system parameters 'regexp_engine=default';

