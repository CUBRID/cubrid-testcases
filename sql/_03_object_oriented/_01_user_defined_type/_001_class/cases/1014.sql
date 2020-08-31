--[er]test alter using to alter method(instance, class) name
set system parameters 'create_table_reuseoid=no';

create class tb2(
	col1 char(8)
)
method class get_2000() int function TEST_getInt
file '$HOME/method_test/myyang';

create class tb1(
	col1 int,
	col2 tb2
);

alter class tb2 rename method get_2000 as get_3000;

drop class tb2;
drop class tb1;

----------------------------------------------------------------

create class tb2(
	col1 char(8)
)
method get_2000() int function TEST_getInt
file '$HOME/method_test/myyang';

create class tb1(
	col1 int,
	col2 tb2
);

alter class tb2 rename method class get_2000 as get_3000;

drop class tb2;
drop class tb1;

set system parameters 'create_table_reuseoid=yes';
