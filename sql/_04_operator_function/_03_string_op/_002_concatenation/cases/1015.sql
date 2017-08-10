--test operator + with varchar and varchar, char, constant 
create class tb(
		col1 varchar,
		col2 varchar,
		col3 char(10)
);

insert into tb  values('varchar', 'varchar', 'char');

select col1+col2 from tb;
select col1+col3 from tb;
select col1+'ok' from tb;

drop class tb;

