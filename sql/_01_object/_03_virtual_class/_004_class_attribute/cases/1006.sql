--querypart's varchar type size different to vclass's varchar type size
CREATE CLASS Student(
    id int auto_increment PRIMARY KEY,
    name varchar(10)
);

insert into Student (name) values('aaa');
insert into Student (name) values('bbb');
insert into Student (name) values('ccc');

create vclass vStudent(
    id,
    name varchar(20)
)
as select * from Student;

select * from vStudent order by 1;

drop vclass vStudent;
drop class Student;

