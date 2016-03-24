-- [er] create  vclass using Constraints null, Unique and SHARED

create vclass t1 (
c1 int  null Unique SHARED 9 
);

drop t1;