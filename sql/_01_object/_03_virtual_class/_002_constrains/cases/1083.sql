-- [er]create vclass using Constraints UNIQUE and null

create vclass t1 (
id int ,
c1 int  null UNIQUE
);

drop t1;