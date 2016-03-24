
drop table if exists foo,d3201;
drop v1,v2,dv1,dv2;
create table foo (i int primary key, j int);
create view v1 as select i from foo order by j;

insert into foo values(1, 3);
insert into foo values(2, 2);
insert into foo values(3, 5);
insert into foo values(4, 4);
insert into foo values(5, 1);

select * from v1;
select * from v1 where i > 3;
select * from v1 order by i;

create view v2(a int) as select i from foo order by j;

select * from v2;
select * from v2 where a > 3;
select * from v2 order by a;

create table d3201 (i int primary key, j int);
create view dv1 as select i from foo order by j;

insert into d3201 values(1, 3);
insert into d3201 values(2, 2);
insert into d3201 values(3, 5);
insert into d3201 values(4, 4);
insert into d3201 values(5, 1);

select * from dv1;
select * from dv1 where i > 3;
select * from dv1 order by i;

create view dv2(a int) as select i from d3201 order by j;

select * from dv2;
select * from dv2 where a > 3;
select * from dv2 order by a;

drop table if exists foo,d3201;
drop v1,v2,dv1,dv2;

drop table if exists foo;
drop v;

create table foo (i int, j int);
create view v as select i from foo order by j;

drop table if exists foo;
drop v;
