--create vclass attribute with all colmuns and retrieve from db_vclass
CREATE CLASS Student(
    sUnique integer unique,
    sNotnull integer not null,
    sDefault integer default 10
);

insert into Student (sUnique, sNotnull) values(11, 12);
insert into Student (sUnique, sNotnull) values(21, 22);
insert into Student (sUnique, sNotnull) values(31, 32);

create vclass vStudent(
    sUnique integer,
    sNotnull integer,
    sDefault integer
)
as select * from Student;

select * from vStudent order by 1,2,3;

select * from db_vclass
where vclass_name = 'vstudent'
order by 1;

drop vclass vStudent;
drop class Student;
