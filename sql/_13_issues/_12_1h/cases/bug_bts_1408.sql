set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop if exists participant2;
CREATE TABLE participant2 ( host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
 ( PARTITION before_2000 VALUES LESS THAN (2000),
 PARTITION before_2008 VALUES LESS THAN (2008) );
 
 ALTER TABLE participant2 REORGANIZE PARTITION before_2000 INTO (
 PARTITION before_1996 VALUES LESS THAN (1996),
 PARTITION before_2000 VALUES LESS THAN (2000)
);

select * from db_partition order by 2;
select * from _db_partition order by pname;

insert into participant2 values(1998,'USA',10,20,30);

ALTER TABLE participant2 REORGANIZE PARTITION before_2000,before_2008 into (
PARTITION before_2008 VALUES LESS THAN (2008));

select * from db_partition order by 2;
select * from _db_partition order by pname;

select participant2 into :x from participant2;

drop table participant2;
select * from db_partition;
select * from _db_partition;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
