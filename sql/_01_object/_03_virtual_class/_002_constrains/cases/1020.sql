-- [er] create class using Constraints UNIQUE and not null

create vclass t1 (
id int ,
c1 int UNIQUE not null
);

drop t1;
