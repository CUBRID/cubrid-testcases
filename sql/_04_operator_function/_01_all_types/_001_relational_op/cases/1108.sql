--[er]test <> operator with numeric and date type
create class tb ( 
	id int auto_increment primary key,
	col1 numeric
);

insert into tb (col1) values(-32768);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);

select * from tb where col1 <> to_date('5/5/2008');

drop table tb;

