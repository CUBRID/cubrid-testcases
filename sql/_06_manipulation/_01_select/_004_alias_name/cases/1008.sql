set system parameters 'create_table_reuseoid=no';
--[er]test class name, alias using a ambiguous column

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

select var_col,ref_col.int_col, int_col from DML_0001, DML_0002 order by 1;

drop class DML_0001;
drop class DML_0002;
set system parameters 'create_table_reuseoid=yes';
