drop table if exists t;
create table t(i int,j varchar(10),k char(10),l int);
insert into t values(1,2,3,1);
insert into t values(2,3,1,2);
insert into t values(3,1,2,3);
insert into t 
with mycte as
(
 select max(i),max(j),max(k),4 from t
) select * from mycte;
select * from t order by l;

with mycte(a,b) as
(
 select i,count(i) from t group by i
) delete t from t,mycte where t.i=mycte.a and mycte.b>1 and t.l=4;
select * from t order by l;

alter table t change i i int unique;
replace into t with mycte as
(
 select max(i),max(j),max(k),4 from t
) select * from mycte;
select * from t order by l;
drop table if exists t;
