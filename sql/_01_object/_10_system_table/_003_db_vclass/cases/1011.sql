--Create vclass without definite data type and retrieve information from db_vclass
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
    sNotnull,
    sDefault
)
as select * from Student;

select * from vStudent order by 1,2;
select * from db_vclass
where vclass_name = 'vstudent';

drop vclass vStudent;
drop class Student;
