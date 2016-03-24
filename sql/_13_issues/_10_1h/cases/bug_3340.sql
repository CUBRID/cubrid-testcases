create table foo (a int, b int);
insert into foo values (1, 1);
create table bar as select * from foo;
drop table bar;
create class bar as select * from foo;
drop table bar;

create table bar (c int) as select * from foo;
drop table bar;
create class bar (c int) as select * from foo;
drop table bar;

create table bar (a int, b int, c int) as select * from foo;
drop table bar;
create class bar (a int, b int, c int) as select * from foo;
drop table bar;

--fail
create table bar as select a,a from foo;
--fail
create class bar as select a,a from foo;
drop table foo;


create type bar as select * from foo; 
create table bar as subclass of foo as select * from foo;
create table bar class attribute (a int UNIQUE) AS SELECT * FROM FOO;
CREATE TABLE BAR METHOD A AS SELECT * FROM FOO;
CREATE TABLE BAR File '/home1/qa/test' as select * from foo;

create class xoo ( a int);
create class yoo under xoo ( b int);
insert into xoo values(1);
insert into yoo values(1, 10);

create table xoo as select x from xoo x;
create table xoo1 as select a from all xoo;
drop xoo1;
create table xoo2 under xoo as select a from all xoo;
create table xoo3 ( class a int) as select a from xoo;
create table xoo4 ( a int, class b int) as select a,b from yoo;
create table xoo4 ( a int, b int shared 1 ) as select a,b from yoo;
drop xoo;
drop yoo;
