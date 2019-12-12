--TEST: [Apricot BB] Semantic: System error (generate attr) with MERGE INTO statement

drop table if exists t;

--server side1
create table t (a varchar(10) NOT NULL, b varchar(10));

merge into t using db_root on (a='a')
when matched then update set b='b'
when not matched then insert (a) values ('a');

select * from t order by 1;

drop table t;


--server side2
create table t (a varchar(10) NOT NULL, b varchar(10));
insert into t values('a', 'aaa');
insert into t values('b', 'bbb');

merge into t using db_root on (a='a')
when matched then update set b='b'
when not matched then insert (a) values ('a');

select * from t order by 1;

drop table t;


--client side1
create table t (a varchar(10) NOT NULL, b varchar(10));

create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before insert on t execute insert into trigger_actions(info) values ('before insert');

merge into t using db_root on (a='a')
when matched then update set b='b'
when not matched then insert (a) values ('a');

select * from t order by 1;
select if(count(*)=1, 'ok', 'nok') from trigger_actions;

drop trigger trigg1;
drop table t, trigger_actions;


--server side2
create table t (a varchar(10) NOT NULL, b varchar(10));
insert into t values('a', 'aaa');
insert into t values('b', 'bbb');

create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before update on t execute insert into trigger_actions(info) values ('before update');

merge into t using db_root on (a='a')
when matched then update set b='b'
when not matched then insert (a) values ('a');

select * from t order by 1;
select if(count(*)=1, 'ok', 'nok') from trigger_actions;

drop trigger trigg1;
drop table t, trigger_actions;


