
-- values upgrade not needed
create table coo(col1 int, col2 date, col3 varchar(10))
partition by range (col2)
(partition p1 values less than (date'1990-12-31'),
 partition p2 values less than(date'2000-12-31'),
 partition p3 values less than(date'2010-12-31'));
 
insert into coo values(11, date'2004-10-19', 'char1');
insert into coo values(22, date'11/23/1951', 'char2');
insert into coo values(33, date'5/14/1998', 'char3');
 
select * from coo order by 1;

alter table coo change col3 col3 varchar(20);

insert into coo values(11, date'2004-10-19', '12345678901234567890');

select * from coo order by 1;

desc coo;

drop table coo;

-- name change
create table coo(col1 int, col2 date)
		partition by range (col2)
			(partition p1 values less than (date'1990-12-31'),
			 partition p2 values less than(date'2000-12-31'));
			 
insert into coo values(11, date'1993-10-19');
insert into coo values(22, date'11/23/1951');
insert into coo values(33, NULL);


select * from coo order by 1;

-- name change
alter table coo change col1 col1_1 bigint;

insert into coo values(123456789012345, date'1994-10-19');

desc coo;

select * from coo order by 1;

drop coo;


---- paritition + hierarchy
create table coo(col1 int, col2 date)
		partition by range (col2)
			(partition p1 values less than (date'1990-12-31'),
			 partition p2 values less than(date'2000-12-31'));

insert into coo values(11, date'1993-10-19');
insert into coo values(22, date'11/23/1951');
insert into coo values(33, NULL);			 

create class foo under coo (col1_2 int, col2_2 int) 
		partition by range (col1_2)
			(partition p1 values less than (1),
			 partition p2 values less than(100));
			 
desc coo;
desc foo;
			 

insert into foo values (1,date'1993-10-19', -1000, 2000);
			 
alter table foo change col2_2 col2_2 bigint;			 
select * from foo order by col1;

alter table foo add column col2_3 int;

insert into foo values (2,date'1993-10-19', -1000, 2000,3000);

select * from foo order by col1;

alter table coo add column col3 int;

insert into foo values (3,date'1993-10-19', 0, -1000, 2000,3000);

select * from coo order by col1;
select * from foo order by col1;

desc coo;
desc foo;

drop foo;
drop coo;
 
