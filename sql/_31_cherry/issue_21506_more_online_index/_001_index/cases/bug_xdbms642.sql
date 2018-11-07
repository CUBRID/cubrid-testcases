--Test index rebuild
create table foo (i int);
create index i_foo_i on foo (i) with online;
alter index i_foo_i on foo rebuild;
drop table foo;


