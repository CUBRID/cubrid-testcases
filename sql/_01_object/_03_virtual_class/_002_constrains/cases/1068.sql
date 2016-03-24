-- [er] create vclass using Constraints null,Unique and DEFAULT 

create vclass t1 (
c1 int Unique  DEFAULT 9 null 
);

drop t1;