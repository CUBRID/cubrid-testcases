--test count function, and it with sum function in select-list 
create class tb(
		col1 varchar,
		col2 char(10),
		col3 int
		);

insert into tb values('varchar01', 'char01', 3);
insert into tb values('varchar02', 'char02', 4);
insert into tb values('varchar03', 'char03', 5);

select count(col3), sum(col3) from tb group by col1;

drop class tb;
