--+ holdcas on;
--test Between, interpreter variable keywords using some select satements

create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select * from DML_0001 where int_col between 1 and 2 order by 1,2,3;
select * from DML_0001 where int_col between 3 and 1 order by 1,2,3;
select * from DML_0001 a, DML_0001 b where a.int_col between 2 and 5 order by 1,2,3,4;
select int_col, int_col+1 into :a,:b from DML_0001 where int_col = 1 order by 1,2;
select * from DML_0001 where int_col between a and b  order by 1,2,3;
select * from DML_0001 where int_col between 1 and 2 and var_col between 'a' and 'z' order by 1,2,3;
select int_col from DML_0001 where var_col between cast(int_col as char) and cast(int_col + 1 as char) order by 1;



drop class DML_0001;
drop variable a, b;

--+ holdcas off;
