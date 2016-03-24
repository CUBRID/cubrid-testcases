-- [er]create vclass using Constraints UNIQUE and default ordering

create vclass t1 (
id int ,
c1 int UNIQUE DEFAULT 0 
);

drop t1;