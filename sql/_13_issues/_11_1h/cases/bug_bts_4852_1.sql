create table coo(col1 int, col2 date, col3 char(10))
partition by range (col2)
(partition p1 values less than (date'1990-12-31'),
partition p2 values less than(date'2000-12-31'),
partition p3 values less than(date'2010-12-31'));

insert into coo values(11, date'2004-10-19', 'char1');
insert into coo values(22, date'11/23/1951', 'char2');
insert into coo values(33, date'5/14/1998', 'char3');

select * from coo order by 1;

alter table coo change col1 col1 bigint;
select * from coo order by 1;

alter table coo change col2 col2 char(20);
select * from coo order by 1;

alter table coo change col3 col3 varchar;
select * from coo order by 1;

drop table coo;



