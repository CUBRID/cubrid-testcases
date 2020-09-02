set system parameters 'create_table_reuseoid=no';
-- [er] tests complex select with  invalid joins.

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

create class DML_0003 under DML_0001( 	int_col1 int not null);

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select a.int_col, b.var_col, b.ref_col.int_col, max(c.int_col)
from DML_0001 a, DML_0002 b left outer join DML_0003 c on b.int_col=c.int_col and b.var_col like '%test%' 
and a.int_col between 1 and 4
where a.int_col = b.int_col
group by a.int_col, b.var_col, b.ref_col.int_col
order by 1,2,3;

drop DML_0001;
drop DML_0002;
drop DML_0003;
set system parameters 'create_table_reuseoid=yes';
