-- it tests 'having' clause with several select queries.
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select * from DML_0001 group by int_col, var_col, set_col having int_col > 1 order by 1,2,3;
select max(int_col) from DML_0001 group by var_col having max(var_col) > 'test1' order by 1;
select int_col from DML_0001 group by set_col,int_col having set_col seteq {1,'test1'} order by 1;
select max(int_col), int_col from DML_0001 group by int_col having int_col*2 > 1 order by 1,2;



drop class DML_0001;
