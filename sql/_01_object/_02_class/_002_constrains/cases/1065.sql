-- [er] create class using Constraints Unique,not  null and SHARED

create table t1 (
c1 int Unique  not null SHARED 9 
);

drop t1;