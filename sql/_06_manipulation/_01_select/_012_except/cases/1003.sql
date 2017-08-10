--[er]test except all keyword using a subquery which has the keyword 'except all'
create class DML_0001
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

select * from all DML_0001 (EXCEPT all DML_0001) order by 1;

drop table dml_0001;

