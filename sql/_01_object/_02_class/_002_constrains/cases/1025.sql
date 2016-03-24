-- create class using Constraints UNIQUE on two columns

create table t1 (
id int UNIQUE,
c1 int  UNIQUE
);

drop t1;