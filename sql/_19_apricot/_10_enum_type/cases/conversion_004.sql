-- conversion from numeric types to enum
create table t1(s smallint, i int, b bigint, f float, d double, n numeric, m monetary);
insert into t1 values (1, 1, 1, 1, 1, 1, 1);
insert into t1 values (2, 3, 3, 2, 4, 1, 2);
insert into t1 values (3, 4, 1, 1.1, 2, 4, 3);

create table t2 (e1 enum('e1', 'e2', 'e3', 'e4', 'e5'));
insert into t2 values (1), (2), (3), (4), (5);
select * from t2 order by 1;

insert into t2 select s from t1;
insert into t2 select i from t1;
insert into t2 select b from t1;
insert into t2 select f from t1;
insert into t2 select d from t1;
insert into t2 select n from t1;
insert into t2 select m from t1;

select * from t2 order by 1;

drop table t1;
drop table t2;
