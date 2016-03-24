-- [er] create vclass using Constraints not null and default

create vclass t1 (
c1 int DEFAULT 9 not null 
);

drop t1;