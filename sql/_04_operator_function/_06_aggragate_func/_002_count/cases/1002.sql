--[er]test the count function using invalid select query.
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select count(t.set_col), t.int_col from (select * from dml_0001 order by 1) t group by t.set_col order by 1,2;


drop class DML_0001;
