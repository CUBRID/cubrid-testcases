-- [er] create class using Constraints not null, Unique and DEFAULT

create table t1 (
c1 int  not null Unique DEFAULT 9 
);

drop t1;