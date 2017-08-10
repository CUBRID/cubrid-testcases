--test column name, alias, All, Distinct , Unique key with several select queries which include these keywords.
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select distinct int_col, var_col, set_col from DML_0001 order by 1,2,3;
select distinct * from DML_0001 order by 1,2,3;
select unique int_col, var_col, set_col from DML_0001 order by 1,2,3;
select distinct var_col + 'test1' from DML_0001 order by 1;
select distinct (count(int_col)) from DML_0001 order by 1;
select all * from DML_0001 order by 1,2,3;
select distinct int_col + 1 as t1 from DML_0001 order by 1;
select int_col c1, var_col c1, set_col c1 from DML_0001 c1 order by 1,2,3;


drop class DML_0001;
