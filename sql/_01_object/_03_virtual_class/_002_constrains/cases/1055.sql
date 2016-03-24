-- [er] create vclass using Constraints null, Unique and SHARED

create vclass t1 (
c1 int  null SHARED 9 Unique
);

drop t1;