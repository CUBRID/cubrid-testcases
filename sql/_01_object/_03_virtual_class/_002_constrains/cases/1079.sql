-- create vclass using Constraints shared

create vclass t1 (
id int ,
c1 int shared 8
);

drop t1;