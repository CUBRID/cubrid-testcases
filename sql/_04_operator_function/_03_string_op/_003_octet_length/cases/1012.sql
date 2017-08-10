--[er]test octet_length with date as parameter
create class tb(
		col1 date
);

insert into tb values('5/5/2005');

select octet_length(col1) from tb;
 
drop class tb;