--test set operators with some select queries.

create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select * from DML_0001 where set_col seteq {1,'test1'}  order by 1,2,3;
select var_col from DML_0001 where set_col SETNEQ {1,'test1'} order by 1;
select * from DML_0001 where set_col SeTnEQ {1,'TeSt1'} order by 1,2,3;
select set_col from DML_0001 where set_col SeTnEQ {1,'TeSt1'} order by 1;
select int_col from DML_0001 where set_col superseteq {1} order by 1;
select * from DML_0001 where set_col subseteq {1,'test1',1,2} order by 1,2,3;
select * from DML_0001 where {int_col} seteq {1,'test1'} order by 1,2,3;
select int_col from DML_0001 where {int_col,var_col} superseteq set_col order by 1;
select * from DML_0001 where multiset {int_col} seteq multiset (select {int_col,var_col} from DML_0001) order by 1,2,3;



drop class DML_0001;