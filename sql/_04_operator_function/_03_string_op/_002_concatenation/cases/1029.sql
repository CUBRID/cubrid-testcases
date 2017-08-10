--[er]test operator + with date and time
create class tb(
		col1 date,
		col2 time
);

insert into tb  values('5/5/2008', '8:8:8 am');

select col1+col2 from tb;


drop class tb;

