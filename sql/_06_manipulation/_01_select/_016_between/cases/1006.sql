--[er]test the Between operator and cast function using a select statement with a undefined variable
create class DML_0001
(       int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select int_col from DML_0001 where var_col between cast(int_col as char) and cast(int_col + z as char);



drop class DML_0001;
