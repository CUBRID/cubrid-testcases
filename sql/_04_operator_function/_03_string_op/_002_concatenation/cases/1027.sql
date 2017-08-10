--[er]test operator + with date and varchar
create class tb(
		col1 date,
		col2 varchar
);

insert into tb  values('5/5/2008', 'varchar');

select col1+col2 from tb;


drop class tb;

