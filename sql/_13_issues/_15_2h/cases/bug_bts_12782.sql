drop table if exists t12366;
create table t12366(a varchar(10), b int not null);
create table if not exists t12366 (like t12366);

drop table t12366;
