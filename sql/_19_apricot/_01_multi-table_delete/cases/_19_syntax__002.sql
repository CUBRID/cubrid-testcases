--CLIENT
create class t_tr(i int, tbl varchar(255));

create class t1 (i int);
create trigger tr1 before delete on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3), (4), (5);

create class t2 (i int);
create trigger tr2 before delete on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (4), (5), (6), (7), (8);

delete from t1 where i < 2;
select * from t1 order by 1;
select * from t_tr order by 1, 2;

delete t1 from t1 where i < 3;
select * from t1 order by 1;
select * from t_tr order by 1, 2;

delete from t1, t2;
delete t1, t2 from t1;
delete t1, t3 from t1, t2;
delete from using t1 where i < 4;
select * from t1 order by 1;
select * from t_tr order by 1, 2;

delete from t1 using t1 where i < 5;
select * from t1 order by 1;
select * from t_tr order by 1, 2;

delete from using t1, t2;
delete from t1, t2 using t1;
delete from t1, t3 using t1, t2;
delete t2 order by i asc;
delete t1, t2 from t1, t2 limit 1;

create index idx on t2(i);
delete t1, t2 from t1, t2 using index idx;

drop class t1;
drop class t2;
drop class t_tr;
