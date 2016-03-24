-- [er] create vclass using Constraints  DEFAULT,null and SHARED

create vclass t1 (
c1 int  SHARED 9 DEFAULT 8 null
);

drop t1;