-- [er]create class using Constraints UNIQUE and Shared 

create table t1 (
id int ,
c1 int  Shared 2 UNIQUE
);

drop t1;