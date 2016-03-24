-- [er] create vclass using Constraints  not null, Unique and DEFAULT

create vclass t1 (
c1 int  not null DEFAULT 9 Unique
);

drop t1;