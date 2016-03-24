-- [er] create vclass using Constraints not null,Unique and SHARED 

create vclass t1 (
c1 int Unique  SHARED 9 not null 
);

drop t1;