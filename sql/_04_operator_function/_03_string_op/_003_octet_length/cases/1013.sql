--[er]test octet_length with time as parameter
create class tb(
		col1 time
);

insert into tb values('5:5:5 am');

select octet_length(col1) from tb;
 
drop class tb;