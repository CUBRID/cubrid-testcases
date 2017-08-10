--[er]test < operator with smallint and char type
create class tb ( 
	id int auto_increment primary key,
	col1 smallint
);

insert into tb (col1) values(-32768);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);

select * from tb where col1<'a';

drop table tb;