--1 table with 2 auto_increment serials


create table foo(a int primary key auto_increment, b string, c short auto_increment);

insert into foo values (null, 'aaa', 100);
select * from foo order by 1;
select last_insert_id();

insert into foo(b) values ('a'), ('b'), ('c'), ('d');
select * from foo order by 1;
select last_insert_id();

insert into foo values (100, 'hhh', 4);
select * from foo order by 1;
select last_insert_id();

insert into foo(b) values ('a'), ('b'), ('c'), ('d');
select * from foo order by 1,2;
select last_insert_id();


drop table foo;
