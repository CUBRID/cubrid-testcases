-- insert data  whith create hash partition table on a timestamp field with size 4 and update data from null and  query data from every partition and then drop table

create table hash_test(id int,     
                           test_time time,
                           test_date date,
                           test_timestamp timestamp, primary key(id,test_timestamp))
        PARTITION BY HASH(test_timestamp)
        PARTITIONS 4;
        insert into hash_test values(1,'08:10:01','2006-01-01','2006-01-01 08:10:01');
        insert into hash_test values(2,'08:20:02','2006-01-11','2006-01-11 08:20:02');
        insert into hash_test values(3,'09:10:03','2006-02-01','2006-02-01 09:10:03');
        insert into hash_test values(4,'09:20:04','2006-02-11','2006-02-11 09:20:04');
        insert into hash_test values(5,'09:30:05','2006-03-01','2006-03-01 10:30:05');
        insert into hash_test values(6,'10:10:06','2006-03-11','2006-03-11 10:40:06');
        insert into hash_test values(7,'10:20:07','2006-04-01','2006-04-01 11:50:07');
        insert into hash_test values(8,'11:30:08','2006-04-11','2006-04-11 11:30:08');
        insert into hash_test values(9,'11:10:09','2006-05-01','2006-05-01 12:40:09');
        insert into hash_test values(10,'12:20:10','2006-05-11','2006-05-11 12:50:10');
        insert into hash_test values(11,'13:10:11','2006-06-01','2007-01-01 08:10:11');
        insert into hash_test values(12,'13:20:12','2006-06-11','2007-01-11 08:20:12');
        insert into hash_test values(13,'14:10:13','2006-07-01','2007-02-01 09:10:13');
        insert into hash_test values(14,'14:20:14','2006-07-11','2007-02-11 09:20:14');
        insert into hash_test values(15,'15:30:15','2006-08-01','2007-03-01 10:30:15');
        insert into hash_test values(16,'15:10:16','2006-08-11','2007-03-11 10:40:16');
        insert into hash_test values(17,'16:20:17','2006-09-01','2007-04-01 11:50:17');
        insert into hash_test values(18,'16:30:18','2006-09-11','2007-04-11 11:30:18');
        insert into hash_test values(19,'17:10:19','2006-10-01','2007-05-01 12:40:19');
        insert into hash_test values(20,'17:20:20','2006-10-11','2007-05-11 12:50:20');

        insert into hash_test values(21,NULL,NULL,NULL);
update hash_test set test_timestamp =  '2007-05-01 12:40:19' where test_timestamp is null;
select * from hash_test order by id;

create table hash_test_new(id int,     
                           test_time time,
                           test_date date,
                           test_timestamp timestamp, primary key(id,test_timestamp))
        PARTITION BY HASH(test_timestamp)
        PARTITIONS 4;

insert into hash_test_new select * from hash_test;

-- must be zero tuple  
select * from hash_test__p__p0 difference select * from hash_test_new__p__p0;
select * from hash_test_new__p__p0 difference select * from hash_test__p__p0;

select * from hash_test__p__p1 difference select * from hash_test_new__p__p1;
select * from hash_test_new__p__p1 difference select * from hash_test__p__p1;

select * from hash_test__p__p2 difference select * from hash_test_new__p__p2;
select * from hash_test_new__p__p2 difference select * from hash_test__p__p2;

select * from hash_test__p__p3 difference select * from hash_test_new__p__p3;
select * from hash_test_new__p__p3 difference select * from hash_test__p__p3;

drop table hash_test;
drop table hash_test_new;
