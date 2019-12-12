--casting result of subquery as set
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select int_col, set (select count(*) from dml_0001) from dml_0001 order by 1,2;
select set {int_col} + set (select Sum(int_col) from dml_0001) from dml_0001 order by 1;
select int_col, set (select count(*) from dml_0001 group by int_col) from dml_0001 order by 1,2;
select int_col, set (select SUM(int_col),Max(var_col) from dml_0001) from dml_0001 order by 1,2;
select int_col,set (select int_col from dml_0001) from dml_0001 order by 1,2;
select int_col,set (select int_col,var_col from dml_0001) from dml_0001 order by 1,2;
select int_col,set (select * from dml_0001) from dml_0001 order by 1,2;
select count(*),set (select int_col from dml_0001) from dml_0001 order by 1,2;


drop class DML_0001;
