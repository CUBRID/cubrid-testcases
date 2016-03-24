-- [er] create class using Constraints  DEFAULT,null and SHARED 

create table t1 (
c1 int null  SHARED 9 DEFAULT 8 
);

drop t1;