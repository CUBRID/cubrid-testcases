--
create table t1(e1 enum('Yes', 'No', 'Cancel'), e2 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'));
insert into t1 values(1, 1), (3, 2), (1, 3), (3, 7), (2, 6), (3, 4), (2, 5);
create index idx on t1(e1);

create view v1 as select * from t1;
create view v2 as select * from t1 where e1 < 3;
create view v3 as select e2 from t1 where e1 =3;
create view v4 as select * from v1 where (e1=1 or e1=2) and e2 > 4;
create view v5 as select * from v3 where e2 > 2;

select * from t1 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
select * from v3 order by 1;
select * from v4 order by 1, 2;
select * from v5 order by 1;

update v3 set e2=e2 - 1;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
select * from v3 order by 1;
select * from v4 order by 1, 2;
select * from v5 order by 1;

select * from v1 where e1 % e2 = 0 order by 1, 2;
select * from v2 where e2 = e1 order by 1, 2;
select * from v3 where e2 / 2 > 0 order by 1;
select * from v4 where e2='Friday'order by 1, 2;
select * from v5 inner join v1 on v5.e2=v1.e2 order by 1, 2, 3;

drop view v1;
drop view v2;
drop view v3;
drop view v4;
drop view v5;
drop table t1;