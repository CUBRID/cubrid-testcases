-- [er] create class using Constraints  DEFAULT, not null and SHARED

create table t1 (
c1 int  DEFAULT 8 SHARED 9 not null
);

drop t1;