-- [er] create vclass using Constraints not null, Unique and SHARED

create vclass t1 (
c1 int  not null Unique SHARED 9 
);

drop t1;