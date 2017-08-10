--[er]test alias using a invalid alias 

create class DML_0001( 	
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

select 12.int_col from DML_0001 as 12 order by 1;

drop class DML_0001;
