-- [er] create vclass using Constraints  DEFAULT, Unique and SHARED

create vclass t1 (
c1 int  DEFAULT 8 Unique SHARED 9 
);

drop t1;