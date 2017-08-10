--[er]test decr function with bit type 
create class tb(
		col0 int auto_increment primary key,
		col1 bit(8)
);

insert into tb (col1) values(b'0010010');
insert into tb (col1) values(b'0010011');

select decr(col1) from tb where col0=1;

drop class tb;
