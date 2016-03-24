drop table if exists foo;
create table foo (a int, b int);
create index idx1 on foo (a);
create index idx2 on foo (b);

update statistics on foo;
update statistics on foo with fullscan;

update statistics on all classes;
update statistics on all classes with fullscan;

update statistics on catalog classes;
update statistics on catalog classes with fullscan;

show index in foo;

drop table foo;
