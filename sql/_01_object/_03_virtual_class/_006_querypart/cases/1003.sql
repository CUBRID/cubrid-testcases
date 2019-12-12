--test querypart with null as a column
create class student(
	id int auto_increment,
	name varchar(10)
);

insert into student (name) values('aaa');

create vclass vstudent(
	address string shared 'no',
	name string
) as select null, name from student;

select * from vstudent;

drop vclass vstudent;
drop class student;