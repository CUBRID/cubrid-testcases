--test count function using it as column name.
create class tb(
		col1 varchar,
		col2 char(10),
		count int
);

insert into tb values('varchar01', 'char01', 3);
insert into tb values('varchar02', 'char02', 4);
insert into tb values('varchar03', 'char03', 5);

select count(count) from tb;

drop class tb;


