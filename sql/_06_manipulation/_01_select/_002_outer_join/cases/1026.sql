set system parameters 'create_table_reuseoid=no';
-- [er]tests complex select with incorrect path expression

create class DML_0001( 	
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002 (	
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
select int_col, var_col, ref_col.int_col, a.int_col from DML_0002 b left outer join table(b.set_ref_col) as t(a)
on b.int_col = a.int_col and b.var_col like '%test%' and a.var_col like '%test%'
where int_col between 1 and 4 and ref_col.int_col between 1 and 4 and a.int_col between 1 and 4
order by 1,2,3,4;


drop class DML_0001;
drop class DML_0002;
drop class DML_0003;
set system parameters 'create_table_reuseoid=yes';
