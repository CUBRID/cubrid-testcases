-- [er] create vclass using Constraints  DEFAULT, null and SHARED

create vclass t1 (
c1 int  DEFAULT 8 null SHARED 9 
);

drop t1;