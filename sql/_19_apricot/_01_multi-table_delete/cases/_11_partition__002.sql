--CLIENT
create class t_tr(i int, tbl varchar(255));

create class t1(id int, city varchar(32), y int) partition by range (y)(
partition bef_1900 values less than (1900),
partition bef_2000 values less than (2000),
partition bef_2012 values less than (2012)
);
create trigger tr1 before delete on t1 execute insert into t_tr values(obj.id, 't1');

insert into t1 values (1, 'Paris', 2011);
insert into t1 values (2, 'London', 2010);
insert into t1 values (3, 'Berlin', 1981);
insert into t1 values (4, 'Moscow', 1989);
insert into t1 values (5, 'Rome', 1945);
insert into t1 values (6, 'Madrid', 1877);
insert into t1 values (7, 'Bucharest', 1854);
insert into t1 values (8, 'Baicoi', 1848);

create class t2(id int, city varchar(32), y int) partition by range (y)(
partition bef_1900 values less than (1900),
partition bef_2000 values less than (2000),
partition bef_2012 values less than (2012)
);
create trigger tr2 before delete on t2 execute insert into t_tr values(obj.id, 't2');
insert into t2 select * from t1;

create class t3(id int);
create trigger tr3 before delete on t3 execute print 'tr3';
insert into t3 values (1), (2), (3), (4), (5);

delete t1, t2 from t1, t2 where t1.y < 1890 and t2.y < 1890;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

delete t2 from t1, t2 where t2.y < 1980;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

delete t3, t1 from t3, t1 where t1.y < 2000 and t3.id < 3;
select * from t3 order by 1;
select * from t1 order by 1;
select * from t_tr order by 1, 2;

drop class t1;
drop class t2;
drop class t3;
drop class t_tr;
