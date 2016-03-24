-- [er] create vclass using Constraints  DEFAULT, null and SHARED

create vclass t1 (
c1 int  SHARED 9 null DEFAULT 8 
);

drop t1;