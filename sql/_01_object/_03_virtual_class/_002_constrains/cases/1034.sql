-- [er] create vclass using Constraints  DEFAULT and SHARED

create vclass t1 (
c1 int  DEFAULT 8 SHARED 9
);

drop t1;