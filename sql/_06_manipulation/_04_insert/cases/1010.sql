--[er]test insert with unmatched type(varchar, int)
create class tb(
	col1 varchar(20)
);

insert into tb values(10);

select * from tb;

drop class tb;