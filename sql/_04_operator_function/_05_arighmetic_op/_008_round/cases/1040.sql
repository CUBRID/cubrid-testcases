set system parameters 'create_table_reuseoid=no';
--create classes,create vclass with LEFT OUTER JOIN ,RIGHT OUTER JOIN  and use  inheritance relationship


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



CREATE VCLASS ddl_0008 UNDER ddl_0007 (
	ref_col ddl_0002
)	as
select int_col, var_col, set_col, ref1_col from ddl_0003;

-- 1 dept
CREATE VCLASS ddl_0009 UNDER ddl_0008 as
	select a.int_col, b.var_col,c.set_col, a.ref_col 
	from ddl_0008 a,ddl_0002 b LEFT OUTER JOIN ddl_0003 c on b.int_col > c.int_col 
	RIGHT OUTER JOIN ddl_0004 d on d.int_col > 1;;

-- 2 dept
CREATE VCLASS ddl_000a UNDER ddl_0009 as
	select a.int_col, b.var_col, c.set_col, d.ref_col 
	from ddl_0002 a LEFT OUTER JOIN ddl_0003 b on a.int_col > b.int_col 
	RIGHT OUTER JOIN ddl_0004 c on c.int_col > 1,ddl_0009 d
	where a.int_col = d.int_col;

-- 3 dept
CREATE VCLASS ddl_000b UNDER ddl_000a as
	select a.int_col, b.var_col, b.set_col, a.ref_col 
	from ddl_000a a, all ddl_0004 b; 

-- 4 dept 
CREATE VCLASS ddl_000c UNDER ddl_000b as
	select * from ddl_000b;

-- 5 dept 
CREATE VCLASS ddl_000d UNDER ddl_000c as
	select * from ddl_000c;




drop vclass ddl_000d;
drop vclass ddl_000c;
drop vclass ddl_000b;
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
