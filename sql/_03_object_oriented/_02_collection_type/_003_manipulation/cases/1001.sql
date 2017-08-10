-- [er]tests a insert data into two class using select with domain and set type,but element value don't match within the domain of the set,then report error

create class DML_0001
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002
(	int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

insert into DML_0002 values ((select int_col+100 from DML_0001 where int_col = 4),
				  (select var_col from DML_0001 where int_col = 4),
				  (select set_col from DML_0001 where int_col = 2),
				  (select DML_0001 from DML_0001 where int_col=1),{set(select DML_0001 from DML_0001)});




drop class DML_0001;
drop class DML_0002;