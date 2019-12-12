drop table if exists t2, t3;

create table t2(id int primary key, name char(5));
create table t3(id int auto_increment, c date);
create trigger trg_t2 before update on t2(id) execute update t3 set c='2013-1-2' comment'comment for trigger';
select name, comment from db_trigger;
select trigger_name, comment from db_trig;

insert into t2 values(1,'22'),(2,'cc');
update t2 set id=5 where name='cc';
select * from t2 order by 1,2;
select * from t3 order by 1,2;

alter trigger trg_t2 comment'this is a testing for trigger comment alter';
select name, comment from db_trigger;
select trigger_name, comment from db_trig;

drop trigger trg_t2;

drop table if exists t2, t3;
