--CLIENT
create class t_tr(i int, tbl varchar(255));

create class t1 (i int);
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i, 't1');
create index idx on t1(i);

insert into t1 values (1), (2), (3), (4), (5);
insert into t1 values (6), (7), (8), (9), (10);
insert into t1 values (11), (12), (13), (14), (15);
insert into t1 values (16), (17), (18), (19), (20);
insert into t1 values (21), (22), (23), (24), (25);
insert into t1 values (26), (27), (28), (29), (30);
insert into t1 values (31), (32), (33), (34), (35);

create class t2 (i int);
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i, 't2');
create index idx on t2(i);

insert into t2 values (106), (107), (108), (109), (110);
insert into t2 values (111), (112), (113), (114), (115);
insert into t2 values (116), (117), (118), (119), (120);
insert into t2 values (121), (122), (123), (124), (125);
insert into t2 values (126), (127), (128), (129), (130);
insert into t2 values (131), (132), (133), (134), (135);
insert into t2 values (136), (137), (138), (139), (140);

update t1 inner join t2 on t1.i=t2.i - 100 set t1.i=t2.i-50;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

update t1 right join t2 on t1.i=t2.i - 50 set t2.i=t2.i-10;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

drop table t1;
drop table t2;
drop table t_tr;