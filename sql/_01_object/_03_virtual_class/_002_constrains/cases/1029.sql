--  create vclass using Constraints not null and SHARED

create vclass t1 (
c1 int SHARED 9 not null 
);

drop t1;