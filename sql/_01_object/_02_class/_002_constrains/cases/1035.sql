-- [er] create class using Constraints  DEFAULT and SHARED

create table t1 (
c1 int  SHARED 9 DEFAULT 8
);

drop t1;