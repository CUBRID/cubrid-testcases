-- [er] create class using Constraints  not null, Unique and SHARED

create table t1 (
c1 int  not null SHARED 9 Unique
);

drop t1;