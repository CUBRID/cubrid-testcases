-- create table of hash partition having size 4 on char field and alter table add partition from 4 to 8

create table hash_test(id int  ,
		       test_int int,
		       test_char char(50),
		       test_varchar varchar(2000),
		       test_timestamp timestamp,primary key(id,test_char)
)
PARTITION BY HASH(test_char)
PARTITIONS 4;
insert into hash_test values (1,1,'aaa','aaa','2000-01-01 09:00:00');
insert into hash_test values (2,2,'bbb','bbb','2000-01-02 09:00:00');
insert into hash_test values (3,3,'ccc','ccc','2000-01-03 09:00:00');
insert into hash_test values (4,11,'ddd','ddd','2000-02-01 09:00:00');
insert into hash_test values (5,12,'eee','eee','2000-02-02 09:00:00');
insert into hash_test values (6,13,'fff','fff','2000-02-03 09:00:00');
insert into hash_test values (7,21,'ggg','ggg','2000-03-01 09:00:00');
insert into hash_test values (8,22,'hhh','hhh','2000-03-02 09:00:00');
insert into hash_test values (9,23,'iii','iii','2000-03-03 09:00:00');
insert into hash_test values (10,31,'jjj','jjj','2000-04-01 09:00:00');

select * from db_partition order by 3,4;
select * from hash_test__p__p0 order by 1,2;
select * from hash_test__p__p1 order by 1,2;
select * from hash_test__p__p2 order by 1,2;
select * from hash_test__p__p3 order by 1,2;

ALTER TABLE hash_test ADD PARTITION PARTITIONS 4;

select * from db_partition order by 3,4;

select * from hash_test order by 1,2;
select * from hash_test__p__p0 order by 1,2;
select * from hash_test__p__p1 order by 1,2;
select * from hash_test__p__p2 order by 1,2;
select * from hash_test__p__p3 order by 1,2;
select * from hash_test__p__p4 order by 1,2;
select * from hash_test__p__p5 order by 1,2;
select * from hash_test__p__p6 order by 1,2;
select * from hash_test__p__p7 order by 1,2;

drop table hash_test;
