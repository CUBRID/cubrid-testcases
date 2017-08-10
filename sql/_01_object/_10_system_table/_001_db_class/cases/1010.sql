--test not null of constraint using integer and varchar data type and retrieve information from db_class

create class DML_0001 
( 	int_col integer not null,
    var_col varchar(20) );

INSERT into DML_0001 values(1,'xdbms');
insert into DML_0001 values(1,'');

select * from DML_0001 ;

select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where class_name = 'dml_0001';

drop class DML_0001 ;