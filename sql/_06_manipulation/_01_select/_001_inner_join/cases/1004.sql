--test derived table with some select queries and set type column.

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

select int_col, var_col, aa from dml_0002, table(set_col) as t(aa) order by 1,2,3;
select * from dml_0002, table(set_col) as t(aa) order by 1,2,3,4 desc;
select * from dml_0002, table({int_col}) as t(aa) order by 1,2,3,4;
select * from dml_0001, (select int_col from dml_0001) as t(aa) order by 1,2,3,4;
select int_col, var_col, aa from dml_0001, (select var_col from dml_0001) as t(aa) order by 1,2,3;
select int_col, var_col, aa from dml_0001, (select set_col from dml_0001) as t(aa) order by 1,2,3;

drop class DML_0001;
drop class DML_0002;
