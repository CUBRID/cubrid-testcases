-- [er] create vclass using Constraints not null and SHARED

create vclass t1 (
c1 int not null SHARED 9 
);

drop t1;