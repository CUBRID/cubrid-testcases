-- [er] create vclass using Constraints null,Unique and DEFAULT

create vclass t1 (
c1 int Unique  null DEFAULT 9 
);

drop t1;