--[er]test alias using class name instead of alias

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

select a.int_col, DML_0002.var_col, a.ref_col.int_col from DML_0002 as a order by 1;

drop class DML_0002;
drop class DML_0001;
