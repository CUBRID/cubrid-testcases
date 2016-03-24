-- [er] create vclass using Constraints  not null, Unique and SHARED

create vclass t1 (
c1 int  not null SHARED 9 Unique
);

drop t1;