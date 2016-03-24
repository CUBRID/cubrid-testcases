-- [er] create class using Constraints not null,Unique and SHARED

create table t1 (
c1 int  SHARED 9 not null Unique
);

drop t1;