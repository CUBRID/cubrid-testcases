-- [er] create vclass using Constraints  DEFAULT,not  null and SHARED

create vclass t1 (
c1 int Unique  DEFAULT 8 SHARED 9 
);

drop t1;