--test create using self reference
set system parameters 'create_table_reuseoid=no';

create vclass tb1(
	col1 int,
	col2 tb1
);

drop vclass tb1;

set system parameters 'create_table_reuseoid=yes';
