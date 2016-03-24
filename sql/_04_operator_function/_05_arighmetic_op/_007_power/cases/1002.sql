--create classes,create a vclass,create a vclass based on a created class and inherited from another created class, create a vclass use gropu by function  


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

CREATE VCLASS ddl_0008 UNDER ddl_0007 
as
select a.int_col, a.var_col,a.set_col from ddl_0002 a;

-- group by
CREATE VCLASS ddl_0009 UNDER ddl_0007 (
	int_col int,
	var_col varchar(20),
	set_col set(int),
	ref_col ddl_0005
) as
select Max(a.int_col), a.var_col,a.set_col, a.ref4_col 
from ddl_0006 a 
group by a.var_col,a.set_col,a.ref4_col;




drop vclass ddl_0009;
drop vclass ddl_0008;
drop vclass ddl_0007;
drop class ddl_0006;
drop class ddl_0005;
drop class ddl_0004;
drop class ddl_0003;
drop class ddl_0002;
drop class ddl_0001;