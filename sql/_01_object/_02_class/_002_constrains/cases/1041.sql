-- [er] create class using Constraints  DEFAULT, null and SHARED

create table t1 (
c1 int null  DEFAULT 8 SHARED 9 
);

drop t1;