-- create class using Constraints shared

create table t1 (
id int ,
c1 int shared 8
);

drop t1;