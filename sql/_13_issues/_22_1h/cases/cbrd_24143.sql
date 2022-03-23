drop table if exists foo;
create table foo (a int not null, b int not null, c int);
create index idx1 on foo(a, b) where c=1;
create index idx2 on foo(a, b) where c=2;
drop table foo;

