-- [er] create class using Constraints Unique,not  null and DEFAULT

create table t1 (
c1 int Unique  not null DEFAULT 9 
);

drop t1;