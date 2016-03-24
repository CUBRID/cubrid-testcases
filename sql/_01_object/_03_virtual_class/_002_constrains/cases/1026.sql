-- [er] create vclass using Constraints not null and default

create vclass t1 (
c1 int not null DEFAULT 9 
);

drop t1;