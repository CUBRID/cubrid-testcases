-- [er] create vclass using Constraints  DEFAULT,Unique and SHARED

create vclass t1 (
c1 int  SHARED 9 DEFAULT 8 Unique
);

drop t1;