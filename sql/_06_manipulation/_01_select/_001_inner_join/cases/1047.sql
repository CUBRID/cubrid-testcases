set system parameters 'create_table_reuseoid=no';
-- [er]tests complex select with  unmatched types.

create class DML_0001( 	
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002 	(	
int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);

create class DML_0003 under DML_0001( 	
int_col1 int not null);

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select b.int_col, b.var_col, b.ref_col.int_col, a.int_col, c 
from DML_0002 as b, table(b.set_ref_col) as t(a), table(b.set_col) as t1(c)
where int_col between 1 and 4 and ref_col.int_col between 1 and 4 and a.int_col between 1 and 4
order by 1,2,3,4;

drop DML_0001;
drop DML_0002;
drop DML_0003;
set system parameters 'create_table_reuseoid=yes';
