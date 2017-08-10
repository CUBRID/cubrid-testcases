-- create two hash partition tables of size 16 and  one of using primary key of another table as foreign key and then drop tables

create table test_oid_27(id int primary key ) partition by hash(id) partitions 16; 

create table test_oid_26(id int , FOREIGN key(id) references test_oid_27(id) ) 
partition by hash(id) partitions 16; 

drop test_oid_26; 
drop test_oid_27;