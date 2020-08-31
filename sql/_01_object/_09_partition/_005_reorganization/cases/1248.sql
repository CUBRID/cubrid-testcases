--alert empty class add attributes and change to range partition with int field having boundary values
set system parameters 'create_table_reuseoid=no';

create class aa1; 
create class bb1; 
alter class aa1 add attribute a int, b bb1; 
alter class bb1 add attribute b int, a aa1; 

alter class aa1 
partition BY RANGE (a) ( 
PARTITION p0 VALUES LESS THAN (10), 
PARTITION p1 VALUES LESS THAN (100) 
); 

alter class bb1 
partition BY RANGE (b) ( 
PARTITION p0 VALUES LESS THAN (10), 
PARTITION p1 VALUES LESS THAN (100) 
); 

drop class bb1;
drop class aa1;

set system parameters 'create_table_reuseoid=yes';
