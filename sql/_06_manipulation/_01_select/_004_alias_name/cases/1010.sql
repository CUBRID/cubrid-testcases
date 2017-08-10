--[er]test class name, alias using incorrect use of '*' 

create class DML_0001( 
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002 	(	
int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);

select *, ref_col.int_col from DML_0002 order by 1;

drop class DML_0002;
drop class DML_0001;
