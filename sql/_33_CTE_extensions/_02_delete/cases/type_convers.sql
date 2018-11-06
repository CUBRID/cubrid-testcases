drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a bit(1000));
WITH cte_peKcVLAkw AS
(
select * from xoo where a = 0
)
delete from t where i <=(select count(*) from cte_peKcVLAkw);
