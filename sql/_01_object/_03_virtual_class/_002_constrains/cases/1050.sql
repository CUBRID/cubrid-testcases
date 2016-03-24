-- [er] create vclass using Constraints  DEFAULT,Unique and SHARED 

create vclass t1 (
c1 int Unique  SHARED 9 DEFAULT 8 
);

drop t1;