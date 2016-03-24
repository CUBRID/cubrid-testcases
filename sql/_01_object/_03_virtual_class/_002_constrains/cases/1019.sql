-- [er]create vclass using Constraints UNIQUE and null

create vclass t1 (
id int ,
c1 int UNIQUE null
);

drop t1;
