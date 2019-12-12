--[er]test class name, alias using incorrect use of alias

create class DML_0001( 	
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

select DML_0001.int_col from DML_0001 a order by 1;

drop class DML_0001;
