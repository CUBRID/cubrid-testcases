-- create class using Constraints UNIQUE and not null

create table t1 (
id int ,
c1 int UNIQUE not null
);

drop t1;

create table t1 (
id int ,
c1 int not null UNIQUE
);

drop t1;