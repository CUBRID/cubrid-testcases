-- [er]create class using Constraints UNIQUE and default ordering

create table t1 (
id int ,
c1 int UNIQUE DEFAULT 0 
);

drop t1;