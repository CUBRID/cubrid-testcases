create table t (i numeric(10,4));
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

insert into t values(2.1);
insert into t values(2.2);
insert into t values(123.456);
insert into t values(123456.1234);
insert into t values(1111.1111);
insert into t values(0.123);
insert into t values(8.123);

select * from t where i < 2 order by i;
select * from t where i < 2.1 order by i;
select * from t where i < cast(2.1 as float) order by i;
select * from t where i < cast(2.1 as double) order by i;
select * from t where i < '2.1' order by i;

select * from t where i > 2 order by i;
select * from t where i > 2.1 order by i;
select * from t where i > cast(2.1 as float) order by i;
select * from t where i > cast(2.1 as double) order by i;
select * from t where i > '2.1' order by i;

select * from t where i <= 2 order by i;
select * from t where i <= cast(2 as float) order by i;
select * from t where i <= cast(2 as double) order by i;
select * from t where i <= '2' order by i;

select * from t where i >= 2 order by i;
select * from t where i >= 2.1 order by i;
select * from t where i >= cast(2.1 as float) order by i;
select * from t where i >= cast(2.1 as double) order by i;
select * from t where i >= '2.1' order by i;
select * from t where i >= 0.123456789123456789123456789 order by i;
select * from t where i >= 10.123456789012345678901234567890 order by i;
select * from t where i = 2.000000 order by i;
select * from t where i = cast(2 as float) order by i;
select * from t where i = cast(2 as double) order by i;
select * from t where i = '2' order by i;

drop table t;

create table t(n numeric(38,0));

insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

select * from t where n < 3.00 order by n;
select * from t where n <= 3.00 order by n;
select * from t where n > 3.00 order by n;
select * from t where n >= 3.00 order by n;
select * from t where n = 3.00 order by n;

drop table t;

create table t (n numeric(28,4));

insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

select * from t where n < cast(3 as numeric(20,16)) order by n;
select * from t where n <= cast(3 as numeric(20,16)) order by n;
select * from t where n > cast(3 as numeric(20,16)) order by n;
select * from t where n >= cast(3 as numeric(20,16)) order by n;
select * from t where n = cast(3 as numeric(20,16)) order by n;

drop table t;

create table t(n numeric(38,0));

insert into t values(-1);
insert into t values(-2);
insert into t values(-3);
insert into t values(-4);
insert into t values(-5);

select * from t where n < -3.00 order by n;
select * from t where n <= -3.00 order by n;
select * from t where n > -3.00 order by n;
select * from t where n >= -3.00 order by n;
select * from t where n = -3.00 order by n;

drop table t;

create table t (n numeric(28,4));

insert into t values(-1);
insert into t values(-2);
insert into t values(-3);
insert into t values(-4);
insert into t values(-5);

select * from t where n < cast(-3 as numeric(20,16)) order by n;
select * from t where n <= cast(-3 as numeric(20,16)) order by n;
select * from t where n > cast(-3 as numeric(20,16)) order by n;
select * from t where n >= cast(-3 as numeric(20,16)) order by n;
select * from t where n = cast(-3 as numeric(20,16)) order by n;

drop table t;