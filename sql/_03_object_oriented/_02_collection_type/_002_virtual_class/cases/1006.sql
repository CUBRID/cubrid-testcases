-- [er]creating vclass with Collection type column and add constraints to attributes whose type is cdt
set system parameters 'create_table_reuseoid=no';

create class t (
a int 
);

create vclass ddl_0001(
	st set(t,int) not null,
	mt multiset(date,char(10)),
	qt SEQUENCE(double,t,t)

);

drop vclass ddl_0001;
DROP CLASS t;

set system parameters 'create_table_reuseoid=yes';
