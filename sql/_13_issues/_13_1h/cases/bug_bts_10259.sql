set system parameters 'create_table_reuseoid=no';
drop if exists s1; 

CREATE TABLE s1(i int, j int) PARTITION BY RANGE(i) (
        PARTITION p0 VALUES LESS THAN (5),
	PARTITION p1 VALUES LESS THAN (10)
);
insert into s1 partition(p0) values (1,1);
select * from s1__p__p0 order by 1;

select incr(i) from s1 partition(p0); 
select incr(i) from s1 partition(p0); 
select incr(i) from s1 partition(p0); 
select incr(i) from s1 partition(p0); 
select incr(i) from s1 partition(p0); 

--test: you will find final value in partition(p0) is not correct. We expect the value is LESS THAN 5.
select * from s1__p__p0 order by 1,2;
drop view v1;
drop if exists s1; 


CREATE TABLE s1(i int , j int,primary key(i,j)) PARTITION BY RANGE(i) (
        PARTITION p0 VALUES LESS THAN (5),
	PARTITION p1 VALUES LESS THAN (10)
);

insert into s1 partition(p1) values (8,8);
select * from s1__p__p1 order by 1,2;

select incr(i) from s1 partition(p1); 
select incr(i) from s1 partition(p1); 
select incr(i) from s1 partition(p1); 

create view v1 as select * from s1 partition (p1);

select * from v1 order by 1,2;

ALTER TABLE s1 PROMOTE PARTITION  p1;

select incr(i) from s1 partition(p1); 
select incr(i) from s1 partition(p1); 
select incr(i) from s1 partition(p1);

select * from v1 order by 1,2;

drop view v1;
drop if exists s1; 
drop if exists s1__p__p1; 





CREATE TABLE s1(i int , j int) PARTITION BY hash(i) partitions 3;

create view v1 as select * from s1 partition (p2);

ALTER TABLE s1 COALESCE PARTITION 2;

ALTER VIEW v1 as select * from s1 partition (p0);

insert into v1 values (1,1);

ALTER VIEW v1 as select * from s1 partition (p1);

ALTER TABLE s1 add partition partitions  10; 

insert into s1 select rownum,rownum from db_class limit 40;

ALTER VIEW v1 as select * from s1 partition (p5);

select incr(i) from s1 partition(p0); 

select * from v1 order by 1,2;

insert into s1 values (1,1);

select * from v1 order by 1;

delete from v1;

drop view v1;

drop if exists s1; 




CREATE TABLE s1(i bigint primary key, j bigint) ;

ALTER TABLE s1 partition by hash(i) partitions  2; 

create view v1 as select * from s1 partition (p1);

insert into v1 values (1,1);
insert into s1 values (2,2);

select incr(i) from s1 ; 

select * from v1 order by 1;
select * from s1 order by 1;

drop view v1;
drop if exists s1; 



set system parameters 'create_table_reuseoid=yes';
