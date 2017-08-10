--check the syntax correctness

create table t(a int);
create index idx on t(a);

update statistics on t with full scan;
update statistics on all classes with full scan;
update statistics on catalog classes with full scan;

update statistics in t with fullscan;
update statistics in all classes with fullscan;
update statistics in catalog classes with fullscan;

update statistics on t fullscan;
update statistics on all tables with fullscan;
update statistics on catalog with fullscan;

update statistics on t with fullscan;
update statistics on all classes with fullscan;
update statistics on catalog classes with fullscan;

show index in t;

drop table t;

