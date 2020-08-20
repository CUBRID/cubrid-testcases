--creating vclass with Collection type column and other types.
set system parameters 'create_table_reuseoid=no';

create class t (
a int 
);

create vclass ddl_0001(
	st set(t),
	mt multiset(t),
	qt SEQUENCE(t)

);

drop vclass ddl_0001;
DROP CLASS t;

set system parameters 'create_table_reuseoid=yes';
