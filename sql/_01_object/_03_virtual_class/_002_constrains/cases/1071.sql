-- [er] create vclass using Constraints null, Unique and DEFAULT

create vclass t1 (
c1 int  null DEFAULT 9 Unique
);

drop t1;