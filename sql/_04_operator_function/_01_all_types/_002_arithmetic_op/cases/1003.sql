--+ holdcas on;
--test various operators(like +,-,*,/) using many select queries and data types.
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select int_col + 4 * 2 / 4 from DML_0001 order by 1;
select 'test1' as t1 , 'test2' as t2, int_col * 7  as t3 from DML_0001 order by 1,2,3;
select 'test1' as t1, 'test2' as t1 from DML_0001 order by 1,2;
select 100, int_col, set_col * set_col from DML_0001 order by 1,2,3;

select set_col + {int_col,var_col} as t1, var_col || '1' from DML_0001 order by 1,2;
set system parameters 'compat_mode=mysql';
select set_col + {int_col,var_col} as t1, concat(var_col, '1') from DML_0001 order by 1,2;
set system parameters 'compat_mode=cubrid';

select set_col - {'test1'} as t1, set_col - {1} as t2 from DML_0001 order by 1,2;
select  {0} + set_col + set_col - set_col  from DML_0001 order by 1;
select set {0} + set_col + set_col - set_col  from DML_0001 order by 1;
select to_char(int_col) + 'test1' from DML_0001 order by 1;


drop class DML_0001;
commit;
--+ holdcas off;
