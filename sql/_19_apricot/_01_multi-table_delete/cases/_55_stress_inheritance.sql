create class t (i int);
insert into t values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
insert into t select t1.* from t as t1, t as t2;

create class t1 under t(i1 int);
insert into t1 select t.i, t.i from t;

create class t11 under t1(v11 varchar(32));
insert into t11 select t.i, t.i, cast(t.i as varchar(32)) from t;

create class t12 under t1(f12 float);
insert into t12 select t.i, t.i, t.i from t;

create class t13 under t1(d13 double);
insert into t13 select t.i, t.i, t.i from t;

create class t14 under t1(c14 char(32));
insert into t14 select t.i, t.i, v11 from t11 as t;

create class t15 under t1(dt15 date);
insert into t15 select t.i, t.i, now() from t;

create class t2 under t(v2 varchar(32));
insert into t2 select t.i, t.v11 from t11 as t;

create class t21 under t2(f21 float);
insert into t21 select t.i, t.v11, t.i from t11 as t;

create class t211 under t21(dt211 date);
insert into t211 select t.i, t.v11, t.i, now() from t11 as t;

create class t2111 under t211(i2111 int);
insert into t2111 select t.i, t.v11, t.i, now(), t.i from t11 as t;

create class t3 under t(f3 float);
insert into t3 select t.i, t.i from t;

create class t4 under t(d4 double);
insert into t4 select t.i, t.i from t;

create class t41 under t4(f41 float);
insert into t41 select t.i, t.i, t.i from t;

create class t5 under t(c5 char(32));
insert into t5 select t.i, t.v11 from t11 as t;

create class u (i int);
insert into u select t.i from t;

delete t, u from all t inner join all u on t.i=u.i where t.i != 1;

select count(*) from t order by 1;
select count(*) from t1 order by 1;
select count(*) from t11 order by 1;
select count(*) from t12 order by 1;
select count(*) from t13 order by 1;
select count(*) from t14 order by 1;
select count(*) from t15 order by 1;
select count(*) from t2 order by 1;
select count(*) from t21 order by 1;
select count(*) from t211 order by 1;
select count(*) from t2111 order by 1;
select count(*) from t3 order by 1;
select count(*) from t4 order by 1;
select count(*) from t41 order by 1;
select count(*) from t5 order by 1;
select count(*) from u order by 1;

drop class t;
drop class t1;
drop class t11;
drop class t12;
drop class t13;
drop class t14;
drop class t15;
drop class t2;
drop class t21;
drop class t211;
drop class t2111;
drop class t3;
drop class t4;
drop class t41;
drop class t5;
drop class u;
