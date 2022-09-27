drop table if exists foo;
create table foo (a int not null, b int not null, c char(10));
create index idx2 on foo(c) where c > 'A';
create index idx1 on foo(c);
drop index idx1 on foo;
drop index idx2 on foo;
drop table foo;
