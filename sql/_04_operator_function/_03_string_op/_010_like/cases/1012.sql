--[er]test like function with time and other types
create class tb(
	col1 time
);

insert into tb values('8:8:2 am');
insert into tb values('8:8:12 am');

select * from tb where col1 like 1;
select * from tb where col1 like b'0001';
select * from tb where col1 like {1,2};
select * from tb where col1 like 1.23;
select * from tb where col1 like '%8%';
select * from tb where col1 like n'%8%';

drop class tb;

