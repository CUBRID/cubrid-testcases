--[er]test incr function with timestamp type
create class tb(
		col0 int auto_increment primary key,
		col1 timestamp
);

insert into tb (col1) values(timestamp'2/2/2002 8:8:8 am');
insert into tb (col1) values(timestamp'2/2/2003 8:8:8 am');

select incr(col1) from tb where col0=1;

drop class tb;
