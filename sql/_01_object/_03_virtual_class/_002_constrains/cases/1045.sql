-- [er] create vclass using Constraints  DEFAULT, not null and SHARED

create vclass t1 (
c1 int  DEFAULT 8 not null SHARED 9 
);

drop t1;