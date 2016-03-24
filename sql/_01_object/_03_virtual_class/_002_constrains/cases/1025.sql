-- [er]create vclass using Constraints UNIQUE on two columns

create vclass t1 (
id int UNIQUE,
c1 int  UNIQUE
);

drop t1;