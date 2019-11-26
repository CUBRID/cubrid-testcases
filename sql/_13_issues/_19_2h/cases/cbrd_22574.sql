--+ holdcas on;
drop table if exists t1;
create table t1 ( a set(int) );
insert into t1 values( {1,2,3,4,5} );
select a into set1 from t1;

--test: csql crashed for below:
select avg(set1) from table(set1);
select json_objectagg(set1,set1)  from table(set1);
drop table if exists t1;

--+ holdcas off;
