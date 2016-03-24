-- [er] create vclass using Constraints null,Unique and SHARED 

create vclass t1 (
c1 int Unique  SHARED 9 null 
);

drop t1;