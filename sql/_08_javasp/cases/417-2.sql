-- trigger

autocommit off;

CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';

create table x411 ( x int, y string);
create table x411_1 ( evnt string, val int);

insert into x411 values(1, '111');
$integer,$2;
insert into x411 values(?, '222') ;

create trigger t411_1 after insert on x411 execute call test1(obj.x);
create trigger t411_2 after update on x411 execute call test1(obj.x);
create trigger t411_3 before delete on x411 execute call test1(obj.x);

select * from x411 order by x,y;

insert into x411 values(3, '333');
update x411 set y = '999';
select * from x411 order by x asc;
delete from x411;


rollback;
autocommit on;

