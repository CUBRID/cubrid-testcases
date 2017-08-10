--[er]definiction columns of vclass with unmatched data type. 
CREATE CLASS Student(
    sUnique integer unique,
    sNotnull integer not null,
    sDefault integer default 10
);

insert into Student (sUnique, sNotnull) values(11, 12);
insert into Student (sUnique, sNotnull) values(21, 22);
insert into Student (sUnique, sNotnull) values(31, 32);

create vclass vStudent(
    sUnique,
    sNotnull varchar(20),
    sDefault
)
as select * from Student;

select * from vStudent;

drop vclass vStudent;
drop class Student;
