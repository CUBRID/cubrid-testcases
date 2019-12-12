-- create table of hash partition having size 4 on char field and change  partition to 1 and then change pristine partition

create table hash_test(id int  ,
		       test_char char(50),
		       test_varchar varchar(2000),primary key(id,test_char)
)
PARTITION BY HASH(test_char)
PARTITIONS 4;
	insert into hash_test values(1,'aaa','aaa');
	insert into hash_test values(2,'bbb','bbb');
	insert into hash_test values(3,'ccc','ccc');
	insert into hash_test values(4,'ddd','ddd');
	insert into hash_test values(5,'eee','eee');
	insert into hash_test values(6,'fff','fff');
	insert into hash_test values(7,'ggg','ggg');
	insert into hash_test values(8,'hhh','hhh');
	insert into hash_test values(9,'iii','iii');
	insert into hash_test values(10,'jjj','jjj');
	insert into hash_test values(11,'kkk','kkk');
	insert into hash_test values(12,'lll','lll');
	insert into hash_test values(13,'mmm','mmm');
	insert into hash_test values(14,'nnn','nnn');
	insert into hash_test values(15,'ooo','ooo');
	insert into hash_test values(16,'ppp','ppp');
	insert into hash_test values(17,'qqq','qqq');
	insert into hash_test values(18,'rrr','rrr');
	insert into hash_test values(19,'sss','sss');
	insert into hash_test values(20,'ttt','ttt');
	insert into hash_test values(21,NULL,NULL);

select * from hash_test__p__p0 order by id;
select * from hash_test__p__p1 order by id;
select * from hash_test__p__p2 order by id;
select * from hash_test__p__p3 order by id;

ALTER TABLE hash_test COALESCE PARTITION 3;

select * from db_partition order by 1,2;

select * from hash_test order by id;
select * from hash_test__p__p0 order by id;

ALTER TABLE hash_test ADD PARTITION PARTITIONS 3;
select * from hash_test__p__p0 order by id;
select * from hash_test__p__p1 order by id;
select * from hash_test__p__p2 order by id;
select * from hash_test__p__p3 order by id;

drop table hash_test;
