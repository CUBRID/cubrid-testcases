set system parameters 'create_table_reuseoid=no';
--create classes ,create vclasses with 'between and' keyword and use inheritance relationship

CREATE CLASS ddl_0001 (
	int_col int,
	var_col varchar(20),
	set_col set(int)
);

CREATE CLASS ddl_0002 UNDER ddl_0001 (
	ref_col ddl_0001
);

CREATE CLASS ddl_0003 UNDER ddl_0002 (
	ref1_col ddl_0002
);

CREATE CLASS ddl_0004 UNDER ddl_0003 (
	ref2_col ddl_0003
);

CREATE CLASS ddl_0005 UNDER ddl_0004 (
	ref3_col ddl_0004
);

CREATE CLASS ddl_0006 UNDER ddl_0005 (
	ref4_col ddl_0005
);

CREATE VCLASS ddl_0007 (
	int_col int,
	var_col varchar(20),
	set_col set(int)
);

CREATE VCLASS ddl_0008 UNDER ddl_0007 as
	select int_col, var_col, set_col
	from all ddl_0001
	where int_col between 1 and 5;

CREATE VCLASS ddl_0009 UNDER ddl_0007 as 
	select int_col, var_col, set_col
	from all ddl_0001 (except (ddl_0002, ddl_0003))
	where int_col between 1 and 5;

CREATE VCLASS ddl_000a UNDER ddl_0007 as
	select int_col, var_col, set_col
	from all ddl_0007 (except (ddl_0008,ddl_0009))
	where int_col between 1 and 5;





drop vclass ddl_000a;
drop vclass ddl_0009;
drop vclass ddl_0008;
drop vclass ddl_0007;
drop class ddl_0006;
drop class ddl_0005;
drop class ddl_0004;
drop class ddl_0003;
drop class ddl_0002;
drop class ddl_0001;
set system parameters 'create_table_reuseoid=yes';
