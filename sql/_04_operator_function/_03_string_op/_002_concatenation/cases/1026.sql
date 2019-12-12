--test operator || with date and int
create class tb(
		col1 date,
		col2 int
);

insert into tb  values('5/5/2008', 3);

select col1+col2 from tb;


drop class tb;

