create table t (i int);

create index idx on t(i) where i = rand();
create index idx on t(i) where rand()<>0;
create index idx on t(i) where i = now();
create index idx on t(i) where now()<>0;

create index idx on t(i);
alter index idx on t(i) where i = rand() rebuild;
alter index idx on t(i) where rand()<>0 rebuild;
alter index idx on t(i) where i = now() rebuild;
alter index idx on t(i) where now()<>0 rebuild;

drop table t;
