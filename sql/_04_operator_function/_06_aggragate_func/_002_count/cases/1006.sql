--test count function with three operands
create class tb(
		col1 varchar,
		col2 char(10),
		col3 string
		);

insert into tb values('varchar01', 'char01', 'string01');
insert into tb values('varchar02', 'char02', 'string02');
insert into tb values('varchar03', 'char03', 'string03');

select count(col1), count(col2), count(col3) from tb;

select count(col1, col2, col3) from tb;

drop class tb;
