-- [er] create vclass using Constraints  DEFAULT, Unique and SHARED

create vclass t1 (
c1 int  DEFAULT 8 SHARED 9 Unique
);

drop t1;