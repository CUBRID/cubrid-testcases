--[er]test like function with bit and other types
create class tb(
	col1 bit(10)
);

insert into tb values(b'001001010');
insert into tb values(b'001001011');

select * from tb where col1 like 1;
select * from tb where col1 like b'0001';
select * from tb where col1 like {1,2};
select * from tb where col1 like 1.23;
select * from tb where col1 like '%8%';
select * from tb where col1 like n'%8%';

drop class tb;
