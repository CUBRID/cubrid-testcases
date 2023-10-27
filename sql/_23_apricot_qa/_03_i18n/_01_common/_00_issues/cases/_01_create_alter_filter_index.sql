create table t (i int);

create index idx on t(i) where i = rand();
create index idx on t(i) where rand()<>0;
create index idx on t(i) where i = now();
create index idx on t(i) where now()<>0;

create index idx on t(i);
-- alter failed
alter index idx on t(i) where i = rand() rebuild;
-- alter failed
alter index idx on t(i) where rand()<>0 rebuild;
-- alter failed
alter index idx on t(i) where i = now() rebuild;
-- alter failed
alter index idx on t(i) where now()<>0 rebuild;
-- alter successfully
alter index idx on t rebuild;

drop table t;
