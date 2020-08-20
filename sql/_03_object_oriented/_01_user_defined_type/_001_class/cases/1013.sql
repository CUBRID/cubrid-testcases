--test create using self reference
set system parameters 'create_table_reuseoid=no';

create class tb1(
	col1 int,
	col2 tb1
);

drop class tb1;

set system parameters 'create_table_reuseoid=yes';
