--test add constraint using alter statement
set system parameters 'create_table_reuseoid=no';

create class tb2(
	col1 char(8)
);

create class tb1(
	col1 int,
	col2 tb2
);

alter class tb2 add constraint aaa unique(col1);

drop class tb2;
drop class tb1;

set system parameters 'create_table_reuseoid=yes';
