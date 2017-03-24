drop table if exists t;
create table t (i int primary key auto_increment, j int);
alter table t
add column col01 numeric not null,
add column col02 numeric not null,
add column col03 numeric not null,
add column col04 numeric not null,
add column col05 numeric not null,
add column col06 numeric not null,
add column col07 numeric not null,
add column col08 numeric not null,
drop column col08,
drop column col07,
drop column col06;
alter table t rename to tt, add column s string not null, rename to t;
drop table if exists t;
