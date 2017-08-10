--[er]test <> operator with numeric and TIMESTAMP type
create class tb ( 
	id int auto_increment primary key,
	col1 numeric
);

insert into tb (col1) values(-32768);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);

select * from tb where col1 <> TO_TIMESTAMP('10:30:20 AM 12/25/1999');

drop table tb;

