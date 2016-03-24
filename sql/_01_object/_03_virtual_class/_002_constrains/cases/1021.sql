-- [er] create vclass using Constraints UNIQUE and default

create vclass t1 (
id int ,
c1 int DEFAULT 0 UNIQUE
);

drop t1;