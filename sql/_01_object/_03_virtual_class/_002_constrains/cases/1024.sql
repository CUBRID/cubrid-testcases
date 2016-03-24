-- [er]create vclass using Constraints UNIQUE and Shared 

create vclass t1 (
id int ,
c1 int  Shared 2 UNIQUE
);

drop t1;