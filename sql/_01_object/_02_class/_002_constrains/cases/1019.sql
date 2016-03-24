-- create class using Constraints UNIQUE and null

create table t1 (
id int ,
c1 int UNIQUE null
);

drop t1;

create table t1 (
id int ,
c1 int  null UNIQUE
);

drop t1;