-- [er]create lsit partition table and create view using 2nd partition
set system parameters 'create_table_reuseoid=no';

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
partition by list(col1) (
partition p0 values in (1,2,3,4,5),
partition p1 values in (10,11,12,13,14,15)
);
create view xp as select * from t1__p__p1; 
insert into xp ( col1, col2, col3, col4) values(1,0,0,1);


drop class t1;
drop vclass xp;

set system parameters 'create_table_reuseoid=yes';
