--[er]test operator + with date and timestamp
create class tb(
		col1 date,
		col2 timestamp
);

insert into tb  values('5/5/2008', '5/5/2008 8:8:8 am');

select col1+col2 from tb;


drop class tb;

