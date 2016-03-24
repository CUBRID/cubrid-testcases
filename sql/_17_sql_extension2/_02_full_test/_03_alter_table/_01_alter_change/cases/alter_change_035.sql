--partition related change (not supported), by list


create table coo(col1 int, col2 date, col3 char)
partition by range (col1)
(partition p1 values in (1, 11, 111),
partition p2 values in (2, 22, 222),
partition p3 values in (3, 33, 333);

insert into coo values(11, date'2004-10-19', 'char1');
insert into coo values(22, date'11/23/1951', 'char2');
insert into coo values(33, date'5/14/1998', 'char3');

select * from p1 order by 1;
select * from p2 order by 1;
select * from p3 order by 1;


--[er] change name of a column with a partition
alter table coo change col1 col11 int;
--[er] change type of a column with a partition
alter table coo change col1 col1 bigint;
--change other column without a partition defined
alter table coo change col3 col3 varchar after col2;

select * from coo;

drop table coo;
