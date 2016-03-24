-- [er] create vclass using Constraints  DEFAULT, null and SHARED

create vclass t1 (
c1 int  DEFAULT 8 SHARED 9 null
);

drop t1;