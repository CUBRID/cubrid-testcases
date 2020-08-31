--creating vclass with Collection type column consist of multi type
set system parameters 'create_table_reuseoid=no';

create class t (
a int 
);

create vclass ddl_0001(
	st set(t,int),
	mt multiset(date,char(10)),
	qt SEQUENCE(double,time,t)

);

drop vclass ddl_0001;
DROP CLASS t;

set system parameters 'create_table_reuseoid=yes';
