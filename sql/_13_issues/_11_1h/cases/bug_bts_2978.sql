create table foo(a int auto_increment, b varchar(10));
insert into foo(b) values('abc');
insert into foo(b) values('abc');
insert into foo(b) values('abc');
insert into foo(b) values('abc');

select last_insert_id();

drop table foo;
