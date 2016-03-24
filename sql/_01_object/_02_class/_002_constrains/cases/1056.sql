-- [er] create class using Constraints null, Unique and SHARED

create table t1 (
c1 int  null Unique SHARED 9 
);

drop t1;