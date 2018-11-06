drop if exists t;
create table t(i time);
insert into t values('22:23:00');

insert into t
with mycte as
(
SELECT TIME_FORMAT(i, '%H:%i:%s') from t
) select * from mycte;

alter table t add column j varchar(50);
with mycte as
(
SELECT TIME_FORMAT(i, '%H %i %s') from t limit 1
) update t set j=(select * from mycte);
select * from t order by 1,2;

create or replace view v1 as select * from t;
with mycte as
(
SELECT TIME_FORMAT(i, '%H %h %i %s %f') from t limit 1
) update v1 set j=(select * from mycte);

select * from v1 order by 1,2;
select * from t order by 1,2;

drop if exists t,v1;


