--test count function with operators +,-,*,/
create class tb(
		col1 varchar,
		col2 char(10),
		col3 int
);

insert into tb values('varchar01', 'char01', 3);
insert into tb values('varchar02', 'char02', 4);
insert into tb values('varchar03', 'char03', 5);

select count(col1)+10 from tb;
select count(col2)-10 from tb;
select count(col3)*10 from tb;
select count(col3)/10 from tb;

drop class tb;
