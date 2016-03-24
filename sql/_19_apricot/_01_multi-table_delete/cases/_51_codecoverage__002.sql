--SERVER
create class t1 (i int);
create unique index idx on t1(i);

insert into t1 values (1), (2), (3), (4), (5);
insert into t1 values (6), (7), (8), (9), (10);
insert into t1 values (11), (12), (13), (14), (15);
insert into t1 values (16), (17), (18), (19), (20);
insert into t1 values (21), (22), (23), (24), (25);
insert into t1 values (26), (27), (28), (29), (30);
insert into t1 values (31), (32), (33), (34), (35);

create class t11 under t1 (i1 int);
insert into t11 select i + 35, i + 35 from t1;

create class t12 under t1 (i1 int, i2 int, i3 int, i4 int);
insert into t12 select i + 70, i + 70, i + 70, i + 70, i + 70 from t1;
create unique index idx1 on t12(i1);
create unique index idx2 on t12(i2);
create unique index idx3 on t12(i3);
create unique index idx4 on t12(i4);
create unique index idx5 on t12(i1, i2);
create unique index idx6 on t12(i1, i3);
create unique index idx7 on t12(i1, i4);
create unique index idx8 on t12(i2, i3);
create unique index idx9 on t12(i2, i4);
create unique index idx10 on t12(i1, i2, i3);
create unique index idx11 on t12(i1, i2, i4);
create unique index idx12 on t12(i2, i3, i4);

create class t2 (i int);
create unique index idx on t2(i);

insert into t2 values (6), (7), (8), (9), (10);
insert into t2 values (11), (12), (13), (14), (15);
insert into t2 values (16), (17), (18), (19), (20);
insert into t2 values (21), (22), (23), (24), (25);
insert into t2 values (26), (27), (28), (29), (30);
insert into t2 values (31), (32), (33), (34), (35);
insert into t2 values (36), (37), (38), (39), (40);

delete t1, t2 from all t1 inner join t2 on t1.i mod 35=t2.i;
select * from t1 order by 1;
select * from t11 order by 1;
select * from t12 order by 1;
select * from t2 order by 1;

drop class t12;
drop class t11;
drop class t1;
drop class t2;
