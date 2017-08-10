--test the 'Exists' keyword with subqueries.

create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select * from DML_0001 where exists (set_col) order by 1,2,3;
select * from DML_0001 where exists (select * from DML_0001 where int_col > 5)  order by 1,2,3;
select * from DML_0001 where exists ({var_col})  order by 1,2,3;
select * from DML_0001 where exists (select int_col, set_col from DML_0001 where int_col > 5)  order by 1,2,3;
select * from DML_0001 where exists {var_col}  order by 1,2,3;



drop class DML_0001;