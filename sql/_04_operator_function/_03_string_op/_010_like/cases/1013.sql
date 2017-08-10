--[er]test like function with timestamp and other types
create class tb(
	col1 timestamp
);

insert into tb values('2/2/2002 8:8:2 am');
insert into tb values('2/2/2002 8:8:12 am');

select * from tb where col1 like 1;
select * from tb where col1 like b'0001';
select * from tb where col1 like {1,2};
select * from tb where col1 like 1.23;
select * from tb where col1 like '%8%';
select * from tb where col1 like n'%8%';

drop class tb;
