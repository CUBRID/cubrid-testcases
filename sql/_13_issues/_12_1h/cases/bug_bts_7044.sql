--TEST: [Multi-table Update] domain conflict error occurs when updating 2 tables.


create table t1(col1 date);
insert into t1 values(date'1999-01-01'), (date'2000-01-01');

create table t2(col1 smallint, col2 date);
insert into t2 values(5, date'2000-01-01'), (13, '2007-12-12');

select * from t1 right outer join t2 on t1.col1=t2.col2 order by 1;

update t1 right outer join t2 on t1.col1=t2.col2 set t1.col1=adddate(t2.col2, 1), t2.col1=month(t1.col1);

select * from t1 order by 1;
select * from t2 order by 1;


drop table t1, t2;



--client side
create table t1(col1 date);
insert into t1 values(date'1999-01-01'), (date'2000-01-01');

create table t2(col1 smallint, col2 date);
insert into t2 values(5, date'2000-01-01'), (13, '2007-12-12');

create table t3(a int auto_increment, b char(10));
create trigger trigg1 before update on t1 execute insert into t3(b) values('t1');
create trigger trigg2 after update on t2 execute insert into t3(b) values('t2');

select * from t1 right outer join t2 on t1.col1=t2.col2 order by 1;

update t1 right outer join t2 on t1.col1=t2.col2 set t1.col1=adddate(t2.col2, 1), t2.col1=month(t1.col1);

select * from t1 order by 1;
select * from t2 order by 1;
select b from t3 order by 1;

drop trigger trigg1, trigg2;
drop table t1, t2, t3;
