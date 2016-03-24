-- create a class as subclass and retrieve info from db_class


create class DDL_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DDL_0001 values (1,'test1', {1,'test1'});
insert into DDL_0001 values (2,'test1', {1,'test1'});
insert into DDL_0001 values (3,'test2', {1,'test2'});
insert into DDL_0001 values (4,'test1', {2,'test1'});
insert into DDL_0001 values (5,'test2', {2,'test2'});

select * from DDL_0001 order by 1;

create class DDL_0002 under  DDL_0001
( 	int_col1 integer);

select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where class_name = 'ddl_0001';

select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where class_name = 'ddl_0002';

drop class DDL_0001;
drop class DDL_0002;
