--[er]test octet_length with double as parameter
create class tb(
		col1 double
);

insert into tb values(22.22);

select octet_length(col1) from tb;
 
drop class tb;