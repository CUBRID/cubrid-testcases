-- [er]create vclass using Constraints UNIQUE and Shared ordering

create vclass t1 (
id int ,
c1 int UNIQUE Shared 2 
);

drop t1;