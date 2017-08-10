--+ holdcas on;
--Test class with not null constraints and retrieve information from db_class
call login('dba') on class db_user;
create class DML_0001 
( 	int_col integer not null,
var_col varchar(20) );

INSERT into DML_0001 values(1,'xdbms');
insert into DML_0001 values(1,'');

select * from DML_0001  order by 1,2;
select * from db_class
where class_name = 'dml_0001' order by 1,2;

drop class DML_0001 ;
--+ holdcas off;
