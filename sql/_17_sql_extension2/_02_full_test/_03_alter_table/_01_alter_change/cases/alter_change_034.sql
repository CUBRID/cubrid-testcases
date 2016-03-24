--partition related change (not supported), by hash


create table coo(col1 int, col2 date, col3 char(10))
partition by hash (col2) partitions 2;

insert into coo values(11, date'2004-10-19', 'char1');
insert into coo values(22, date'11/23/1951', 'char2');
insert into coo values(33, date'5/14/1998', 'char3');

select * from p1 order by 1;
select * from p2 order by 1;
select * from p3 order by 1;


--[er] change name of a column with a partition
alter table coo change col2 col22 date;
--[er] change type of a column with a partition
alter table coo change col2 col2 timestamp;
--change other column without a partition defined
alter table coo change col1 col1 smallint after col2;

select * from coo order by 1;

drop table coo;
