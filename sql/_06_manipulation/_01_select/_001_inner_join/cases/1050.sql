set system parameters 'create_table_reuseoid=no';
-- [er]tests a Insert data into two class syntax using select with domain and set type,but the number of attributes aren't equal in domain type,then report syntax error


create class DML_0001( 	
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002(	
int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

insert into DML_0002 (int_col, ref_col) ((select int_col+100 from DML_0001 where int_col = 4),
(select DML_0001 from DML_0001 where int_col=1));



drop class DML_0001;
drop class DML_0002;
set system parameters 'create_table_reuseoid=yes';
