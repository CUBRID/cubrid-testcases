-- [er] create class using Constraints UNIQUE and not null

create vclass t1 (
id int ,
c1 int not null UNIQUE
);

drop t1;