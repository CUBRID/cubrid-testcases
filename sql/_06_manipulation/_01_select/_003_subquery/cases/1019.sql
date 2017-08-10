--[er]test the in keyword using some subqueries

create class DML_0001 ( 	
int_col integer,
var_col varchar(20),
set_col set (varchar(10), varchar(10)) );

insert into DML_0001 values (1,'test1', {'1','test1'});
insert into DML_0001 values (2,'test1', {'1','test1'});
insert into DML_0001 values (3,'test2', {'1','test2'});
insert into DML_0001 values (4,'test1', {'2','test1'});
insert into DML_0001 values (5,'test2', {'2','test2'});
select * from DML_0001 where var_col in ('test1','test2') and int_col in (1,2,3) order by 1,2,3;
select * from DML_0001 where var_col in (select var_col from DML_0001 where int_col=3) order by 1,2,3;
select * from DML_0001 where {int_col} in (select * from DML_0001) order by 1,2,3;
select * from DML_0001 where set_col in (select * from DML_0001) order by 1,2,3;
select * from DML_0001 where {int_col, var_col} in (select set_col from DML_0001) order by 1,2,3;
select * from DML_0001 where int_col in (select set_col from DML_0001) order by 1,2,3;

select * from DML_0001 where {int_col} in (select {int_col} from DML_0001) order by 1,2,3;
select * from DML_0001 where set_col in (select set_col from DML_0001) order by 1,2,3;

drop class DML_0001;
