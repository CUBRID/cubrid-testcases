--1 table with 1 auto_increment serial


create table foo(a int auto_increment, b string);

insert into foo values (null, 'aaa');
select * from foo order by 1;
select last_insert_id();

insert into foo(b) values ('a'), ('b'), ('c'), ('d');
select * from foo order by 1;
select last_insert_id();

insert into foo values (100, 'hhh');
select * from foo order by 1;
select last_insert_id();

insert into foo(b) values ('a'), ('b'), ('c'), ('d');
select * from foo order by 1;
select last_insert_id();


drop table foo;
