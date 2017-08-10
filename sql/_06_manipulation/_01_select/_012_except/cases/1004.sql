--[er]test EXCEPT keyword using a subquery with the keyword 'EXCEPT'

create class DML_0001
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

select * from all DML_0001 (EXCEPT (select * from dml_0001)) order by 1;

drop table dml_0001;
