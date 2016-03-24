-- [er]create vclass using Constraints not null,Unique and DEFAULT

create vclass t1 (
c1 int  DEFAULT 9 not null Unique
);

drop t1;