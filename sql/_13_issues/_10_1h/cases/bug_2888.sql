create table foo (f int);
create table scott (s int); 

rename table foo to bar, scot to tiger;
select * from foo;
select * from bar;

rename table foo to bar, scott to tiger;
select * from foo;
select * from bar;
select * from scott;
select * from tiger;

drop table foo;
drop table scott;
drop table bar;
drop table tiger;
