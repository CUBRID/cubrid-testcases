--[er]test octet_length with timestamp as parameter
create class tb(
		col1 timestamp
);

insert into tb values('5/5/2005 5:5:5 am');

select octet_length(col1) from tb;
 
drop class tb;