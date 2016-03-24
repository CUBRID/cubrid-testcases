-- [er]create class using Constraints UNIQUE and Shared ordering

create table t1 (
id int ,
c1 int UNIQUE Shared 2 
);

drop t1;