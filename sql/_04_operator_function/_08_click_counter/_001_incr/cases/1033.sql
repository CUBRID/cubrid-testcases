--[er]test incr function with time type
create class tb(
		col0 int auto_increment primary key,
		col1 time
);

insert into tb (col1) values(time'8:8:8 am');
insert into tb (col1) values(time'8:8:8 am');

select incr(col1) from tb where col0=1;

drop class tb;
