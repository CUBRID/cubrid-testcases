--[er]test decr function with date type
create class tb(
		col0 int auto_increment primary key,
		col1 date
);

insert into tb (col1) values(date'8/8/2008');
insert into tb (col1) values(date'8/9/2008');

select decr(col1) from tb where col0=1;

drop class tb;
