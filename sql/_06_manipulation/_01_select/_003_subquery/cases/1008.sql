--[er]select the same column without its table name

create class DML_0001 ( 
int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

create class DML_0002 ( 
int_col integer,
var_col varchar(20),
set_col set(int) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
insert into DML_0002 values (1,'test1', {1,2,3});
insert into DML_0002 values (2,'test1', {1,3});
insert into DML_0002 values (3,'test2', {1,2});
insert into DML_0002 values (4,'test1', {2,4});
insert into DML_0002 values (5,'test2', {1,2,3,4,5});

select a_var,a_var from (select var_col, int_col from dml_0001) as t1(a_var,a_var),(select var_col from dml_0002) as t2(a_var) order by 1;



drop class DML_0001;
drop class DML_0002;
