--TEST:  [Multi-table Update] NOT NULL violation error occurs in multi-table update when there is no row to update.


create table t1 (id1 int not null);
create table t2 (id2 int not null);

insert into t1 values (1);

-- expected outcome: no error, no changes
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10;

-- expected outcome: no error, changes on t1
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10, t1.id1 = t1.id1 + 1;
select * from t1;

-- expected outcome: no error, no changes
update t2 right outer join t1 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10;

-- expected outcome: error
update t1 left outer join t2 on t1.id1 = t2.id2 set t1.id1 = t2.id2 + 10;

insert into t1 values (1);
insert into t2 values (1);

-- expected outcome: no error, one change on t2
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10;
select * from t2;

-- expected outcome: error
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10, t1.id1=t2.id2*10;

drop table if exists t1,t2;



-- client side
create table t1 (id1 int not null);
create table t2 (id2 int not null);

create table t3 (id int primary key auto_increment, s char(10));
create trigger trigg1 before update on t1 execute insert into t3(s) values('t1');
create trigger trigg2 before update on t2 execute insert into t3(s) values('t2');

insert into t1 values (1);

-- expected outcome: no error, no changes
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10;
select if(count(*)=0, 'ok', 'nok') from t3;

-- expected outcome: no error, changes on t1
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10, t1.id1 = t1.id1 + 1;
select * from t1;
select if(count(*)=1, 'ok', 'nok') from t3;

-- expected outcome: no error, no changes
update t2 right outer join t1 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10;
select if(count(*)=1, 'ok', 'nok') from t3;

-- expected outcome: error
update t1 left outer join t2 on t1.id1 = t2.id2 set t1.id1 = t2.id2 + 10;
select if(count(*)=1, 'ok', 'nok') from t3;

insert into t1 values (1);
insert into t2 values (1);

-- expected outcome: no error, one change on t2
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10;
select * from t2;
select if(count(*)=2, 'ok', 'nok') from t3;

-- expected outcome: error
update t1 left outer join t2 on t1.id1 = t2.id2 set t2.id2 = t2.id2 + 10, t1.id1=t2.id2*10;
select if(count(*)=2, 'ok', 'nok') from t3;

drop trigger trigg1, trigg2;
drop table if exists t1, t2, t3;
