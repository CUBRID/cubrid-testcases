-- trigger

autocommit off;

CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';

create table x411 ( x int, y string);
create table x411_1 ( evnt string, val int);

insert into x411 values(1, '111');
$integer,$2;
insert into x411 values(?, '222') ;

create trigger t411_1 after insert on x411 execute insert into x411_1 values('insert trigger',  test1(obj.x) );
create trigger t411_2 after update on x411 execute insert into x411_1 values ('update trigger',  test1(test1(obj.x)) );
create trigger t411_3 before delete on x411 execute insert into x411_1 values ('delete trigger',  test1(obj.x) );

select * from x411 order by x asc;

insert into x411 values(3, '333');
update x411 set y = '999';
select * from x411 order by x asc;
delete from x411;

create table x411_2 ( x int, y int); 
create table x411_3 ( evnt int, val int);
create table x411_4 ( evnt int, val int);

create trigger t411_4 after insert on x411_2 execute insert into x411_3 values(100, 200);
create trigger t411_5 after insert on x411_3 execute insert into x411_4 values(cast(to_char((obj.evnt)) as numeric(10)), test1(obj.evnt));

insert into x411_2 values(10, 20);

select * from x411_3;
select * from x411_4;

rollback;
autocommit on;

