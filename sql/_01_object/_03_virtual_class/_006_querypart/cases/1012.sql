--test querypart with NA keyword as a column
create class student(
	id int auto_increment,
	name varchar(10)
);

insert into student (name) values('aaa');

create vclass vstudent(
	address string shared 'no',
	name string
) as select NA, name from student;

create vclass vstudent1(
	address string shared 'no',
	name string
) as select NA, name from vstudent;


select * from vstudent;

drop vclass vstudent;
drop vclass vstudent1;
drop class student;