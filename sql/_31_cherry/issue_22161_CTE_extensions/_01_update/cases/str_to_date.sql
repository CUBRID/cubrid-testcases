drop table if exists t,t2;
create table t(j datetimetz,k varchar(50));
insert into t(k) values('2001-10-11 02:03:04 AM Europe/Bucharest EEST');

create or replace view  v1 as select * from t;
with mycte as
(
 SELECT STR_TO_DATE(k, '%Y-%m-%d %h:%i:%s %p %TZR %TZD') as mm from t
) update t set j=(select mm from mycte);

select * from t;


with mycte as
(
 SELECT STR_TO_DATE(k, '%Y-%m-%d %h:%i:%s %p %TZR %TZD') as mm from t
) update v1 set j=(select mm from mycte);

select * from t;
select * from v1;

create  table t2 as select * from t;
insert into t2 values(current_datetime,'2001-10-11 02:03:04 AM Europe/Bucharest EEST');
insert into t2 values('2001-10-11 02:03:04 AM Europe/Bucharest EEST',current_datetime);

with mycte as
(
 SELECT STR_TO_DATE(k, '%Y-%m-%d %h:%i:%s %p %TZR %TZD') as mm from t
) update t2,t set t2.k=(select mm from mycte) where t2.j=t.k;

with mycte as
(
 SELECT STR_TO_DATE(k, '%Y-%m-%d %h:%i:%s %p %TZR %TZD') as mm from t
) update t2,mycte set  t2.j=(select k from t) where t2.k=mm;
select * from t2;


drop if exists t,t2,v1;
