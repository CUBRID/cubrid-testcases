autocommit off;
create class trigx( name char(10), num int);
create class trigy( name char(10), num int);
insert into trigy values( 'test1', 10);
insert into trigy(num) values(20);
insert into trigy values( 'test3', 30);
create trigger test_insert before insert on trigx
if new.name is null execute reject;
insert into trigx select * from trigy;
select * from trigx order by 1,2;
insert into trigx values( 'test1', 10);
insert into trigx(num) values(20);
insert into trigx values( 'test3', 10);
select * from trigx order by 1,2;
create trigger test_update before update on trigx
if new.num > 10 execute reject;
update trigx set num = 20 where num = 10;
select * from trigx order by 1,2;
update trigx set num = 20 where name = 'test1';
update trigx set num = 5 where name = 'test1';
select * from trigx order by 1,2;
create trigger test_delete before delete on trigx
if obj.num = 10 execute reject;
delete from trigx;
select * from trigx order by 1,2;
delete from trigx where num = 10;
delete from trigx where num = 5;
select * from trigx order by 1,2;
rollback;
