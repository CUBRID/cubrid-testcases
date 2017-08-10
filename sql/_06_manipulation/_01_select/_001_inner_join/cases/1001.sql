--+ holdcas on;
--test select column using many kind of column(like subquery, expression, etc)

create class DML_0001 ( 	
int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select int_col, (select count(*) from dml_0001) from dml_0001 order by 1,2;
select int_col / (select Sum(int_col) from dml_0001) from dml_0001 order by 1;
select to_char(cast (int_col as float) / (select Sum(int_col) from dml_0001)) from dml_0001 order by 1;
select int_col + (select Sum(int_col) from dml_0001) from dml_0001 order by 1;
select var_col || (select max(var_col) from dml_0001) from dml_0001 order by 1;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select int_col, (select count(*) from dml_0001) from dml_0001 order by 1,2;
select int_col / (select Sum(int_col) from dml_0001) from dml_0001 order by 1;
select to_char(cast (int_col as float) / (select Sum(int_col) from dml_0001)) from dml_0001 order by 1;
select int_col + (select Sum(int_col) from dml_0001) from dml_0001 order by 1;
select var_col || (select max(var_col) from dml_0001) from dml_0001 order by 1;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';


drop class DML_0001;
commit;
--+ holdcas off;
