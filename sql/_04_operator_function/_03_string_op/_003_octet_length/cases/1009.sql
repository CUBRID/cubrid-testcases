--[er]test octet_length with monetary as parameter
create class tb(
		col1 monetary
);

insert into tb values(22);

select octet_length(col1) from tb;
 
drop class tb;