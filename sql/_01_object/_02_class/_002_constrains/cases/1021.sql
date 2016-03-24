-- create class using Constraints UNIQUE and default

create table t1 (
id int ,
c1 int DEFAULT 0 UNIQUE
);

drop t1;