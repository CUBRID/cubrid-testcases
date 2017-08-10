--[er]test octet_length with float as parameter
create class tb(
		col1 float
);

insert into tb values(22.22);

select octet_length(col1) from tb;
 
drop class tb;