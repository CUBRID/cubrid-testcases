autocommit off;
create table dummy;
select * from dummy;
select d.* from dummy d;
create table foo (f int, g int, h int);
create view foov(f, g, h) as select f, g, h from foo;
create table doo (d set(foo));
create table zoo (z foo);
insert into foo values(1, 2, 3);
select foo.* from foo;		-- simple table
select t.* from foo t;		-- table alias
select foov.* from foov;	-- simple view
select t.* from foov t;		-- view alias
select t.* from (select f, g, h from foo) as t(f, g, h);	-- query derived table
select tab.* from doo, table(d) as tab(f);	-- set derived table
select a.* from foo;		-- error
select a.* from foov;		-- error
select a.* from (select f from foo) as t(f); -- error
select t.*, f from foo t;
select f, t.*, f from foo t;
select f, t.*, t.*, f from foo t;
select f, t.*, t.*, t.*, f from foo t;
select f, t.* from (select f, g, h from foo) as t(f, g, h);	-- query derived table
select t.*, f from (select f, g, h from foo) as t(f, g, h);	-- query derived table
select f, t.*, t.*, t.*, f from (select f, g, h from foo) as t(f, g, h);	-- query derived table
rollback work;
rollback;
