-- [er] create class using Constraints  DEFAULT and SHARED

create table t1 (
c1 int  DEFAULT 8 SHARED 9
);

drop t1;