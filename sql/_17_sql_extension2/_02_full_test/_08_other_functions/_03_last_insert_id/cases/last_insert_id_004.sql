--1 table with 1 auto_increment serial - drop auto_increment throu alter change


create table foo(a int auto_increment, b string);

insert into foo values (null, 'aaa');
select * from foo order by 1;
select last_insert_id();

insert into foo(b) values ('a'), ('b'), ('c'), ('d');
select * from foo order by 1;
select last_insert_id();

--drop auto_increment 
alter table foo change a a int;

insert into foo values (100, 'hhh');
select * from foo order by 1;
select last_insert_id();

insert into foo(b) values ('a'), ('b'), ('c'), ('d');
select * from foo order by 1,2;
select last_insert_id();


drop table foo;
