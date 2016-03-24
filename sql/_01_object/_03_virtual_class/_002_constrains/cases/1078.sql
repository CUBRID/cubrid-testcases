-- create vclass using Constraints default

create vclass t1 (
id int ,
c1 int default 8
);

drop t1;