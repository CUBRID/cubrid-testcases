-- [er] create class using Constraints not null and SHARED

create table t1 (
c1 int not null SHARED 9 
);

drop t1;