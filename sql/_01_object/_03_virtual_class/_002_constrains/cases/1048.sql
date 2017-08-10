-- [er] create  class using Constraints  DEFAULT,Unique and SHARED

create vclass t1 (
c1 int  SHARED 9 Unique DEFAULT 8 
);

drop t1;