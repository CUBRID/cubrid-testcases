-- [er] create class using Constraints  DEFAULT,Unique and SHARED

create table t1 (
c1 int  SHARED 9 DEFAULT 8 Unique
);

drop t1;