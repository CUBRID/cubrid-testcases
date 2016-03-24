--2 tables with 1 auto_increment serial


create table foo(a int primary key auto_increment, b string, c short);

insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
insert into foo values (null, 'aaa', 100);
select * from foo order by 1;
select last_insert_id();

create table aoo(a int auto_increment, b string);
insert into aoo(b) values ('a'), ('b'), ('c'), ('d');
select * from aoo order by 1;
select last_insert_id();

insert into foo(b, c) values ('hhh', 4);
select * from foo order by 1;
select last_insert_id();

insert into aoo(b) values ('a'), ('b'), ('c'), ('d');
select * from aoo order by 1,2;
select last_insert_id();


drop table foo;
drop table aoo;
