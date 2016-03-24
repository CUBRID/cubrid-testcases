-- create hash partition table with int field having size 4 and create view using 2nd partition and retrieve information from db_vlass

create class t1 ( 
col1 int not null , 
col2 int not null, 
col3 int not null, 
col4 integer, 
col5 numeric, 
col6 numeric, 
col7 numeric, 
col8 numeric, 
col9 char(1), 
col10 char(1), 
col11 date, 
col12 date, 
col13 date, 
col14 char(25), 
col15 char(10), 
col16 varchar(44) 
)
partition by hash(col1)
partitions 4;
create view xp as select * from t1__p__p1; 

select * from db_vclass
where vclass_name = 'xp';


drop class t1;
drop vclass xp;
