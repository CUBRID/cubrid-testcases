-- [er] create vclass using Constraints  DEFAULT,not null and SHARED

create vclass t1 (
c1 int  SHARED 9 not null DEFAULT 8 
);

drop t1;