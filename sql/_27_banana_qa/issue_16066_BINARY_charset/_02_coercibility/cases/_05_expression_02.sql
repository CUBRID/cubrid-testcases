--+ holdcas on;
set names binary;
select coercibility( ifnull(date '2010-01-01', _binary'a'));
create table t12278(id int);
select coercibility((select 'A' from db_root limit 1));
drop table t12278;
commit;
--+ holdcas off;