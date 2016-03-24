-- [er] create vclass using Constraints not null, Unique and DEFAULT

create vclass t1 (
c1 int  not null Unique DEFAULT 9 
);

drop t1;