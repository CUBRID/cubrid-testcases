--[er]test count function with nested use of count
create class tb(
		col1 varchar,
		col2 char(10),
		col3 string
		);

insert into tb values('varchar01', 'char01', 'string01');
insert into tb values('varchar02', 'char02', 'string02');
insert into tb values('varchar03', 'char03', 'string03');

select count(count(col1)) from tb group by col1;

drop class tb;
