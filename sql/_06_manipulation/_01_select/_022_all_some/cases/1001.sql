--[er]test the 'all', 'some' keyword with some select statements

create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select * from DML_0001 where int_col > all (select int_col from DML_0001) order by 1,2,3;
select * from DML_0001 where int_col <= all (select int_col from DML_0001) order by 1,2,3;
select * from DML_0001 where int_col <= some (select int_col from DML_0001) order by 1,2,3;
select * from DML_0001 where int_col > all {'test1',1,2} order by 1,2,3;
select * from DML_0001 where int_col <= some {1,2,3,4,5} order by 1,2,3;
select * from DML_0001 where int_col <= some {1,'2',3,'4',5} order by 1,2,3;
select * from DML_0001 where int_col <= all {1,'2',3,'4',5} order by 1,2,3;

select * from DML_0001 where int_col <= some (select * from DML_0001) order by 1,2,3;

drop class DML_0001;