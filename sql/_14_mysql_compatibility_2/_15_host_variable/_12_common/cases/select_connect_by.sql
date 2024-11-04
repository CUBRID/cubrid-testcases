create table tree(id int, parentid double, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,2,'AA');
insert into tree values(4,2,'AB');
insert into tree values(5,3,'BA');
insert into tree values(6,3,'BB');
insert into tree values(7,5,'BBA');

select * from tree order by id;

select * from tree 	connect by prior id=parentid - 1.0 order by id;

prepare st from 'select * from tree connect by prior id=parentid - ? order by id';
execute st using 1.0;
deallocate prepare st;
	
select * from tree start with parentid is null 	connect by prior id=parentid - '1' order by id;

prepare st from 'select * from tree start with parentid is null 	connect by prior id=parentid - ? order by id';
execute st using '1';
deallocate prepare st;


select * from tree start with parentid + 3.0=6 connect by prior id=parentid - '1' order by id;
prepare st from 'select * from tree start with parentid+?=6 connect by prior id=parentid - ? order by id';
execute st using 3.0,'1';
deallocate prepare st;

drop table tree;
