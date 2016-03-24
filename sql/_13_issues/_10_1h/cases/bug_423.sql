set trigger trace off;

create table foo (id int);
create table bar (f foo);
create table zoo (b bar);
insert into foo values(1) into f1;
insert into bar values (f1) into b1;
insert into zoo values (b1);
-- PL detail
select * from (select id from foo) A;
select * from (select foo from foo) A;
select * from (select foo from foo) A(t);
select * from (select foo as X from foo) A;
select * from (select foo as X from foo) A(t);
select foo A from foo;
select * from (select foo from foo) A;
select * from (select f from bar) A;
select * from (select f.id from bar) A;
select * from (select b.f from zoo) A;
select * from (select b.f.id from zoo) A;
select * from (select b.f.id from zoo) A;

drop table foo;
drop table bar;
drop table zoo;