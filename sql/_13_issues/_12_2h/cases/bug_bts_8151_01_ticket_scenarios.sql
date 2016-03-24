-- 8422
create table z1 (a int, b int);

insert into z1 values (1,1);
insert into z1 values (1,2);
insert into z1 values (2,1);

select /*+ recompile */ a,b, ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1;

drop z1;

-- 8151
create table t1(a int, b char(10));
insert into t1 values(1, 'a');
insert into t1 values(2, 'b');
insert into t1 values(4, 'd');

select avg(a) over(partition by a) aaa from t1;

create view v as select avg(a) over(partition by a) aaa from t1;

select * from v;

drop t1, v;

-- 8427
create table z1 (a int, b int);
insert into z1 values (1,1);

create view v1 as select a, b, ROW_NUMBER() over(PARTITION BY a ORDER BY b asc) c11 from z1;

select * from v1;

drop z1, v1;
