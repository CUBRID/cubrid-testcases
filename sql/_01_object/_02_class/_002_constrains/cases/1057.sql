-- [er] create class using Constraints null,Unique and SHARED

create table t1 (
c1 int Unique  null SHARED 9 
);

drop t1;