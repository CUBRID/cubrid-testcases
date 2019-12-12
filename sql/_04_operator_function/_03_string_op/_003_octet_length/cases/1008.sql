--[er]test octet_length with smallint as parameter
create class tb(
		col1 smallint
);

insert into tb values(22);

select octet_length(col1) from tb;
 
drop class tb;