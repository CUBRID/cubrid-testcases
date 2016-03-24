-- [er] create vclass using Constraints Unique,not  null and SHARED

create vclass t1 (
c1 int Unique  not null SHARED 9 
);

drop t1;