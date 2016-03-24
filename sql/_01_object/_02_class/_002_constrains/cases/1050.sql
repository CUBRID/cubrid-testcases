-- [er] create class using Constraints  DEFAULT,Unique and SHARED 

create table t1 (
c1 int Unique  SHARED 9 DEFAULT 8 
);

drop t1;