-- [er]insert data which create a list partition table on int  field and reorganize two partitons to one partition but lost list data

create table list_test(id int not null  ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_int))
PARTITION BY LIST (test_int) (
    PARTITION p0 VALUES IN (1,2,3),
    PARTITION p1 VALUES IN (11,12,13,null),
    PARTITION p2 VALUES IN (21,22,23,31)
);

insert into list_test values (1,1,'aaa','aaa','2000-01-01 09:00:00');
insert into list_test values (2,2,'bbb','bbb','2000-01-02 09:00:00');
insert into list_test values (3,3,'ccc','ccc','2000-01-03 09:00:00');
insert into list_test values (4,11,'ddd','ddd','2000-02-01 09:00:00');
insert into list_test values (5,12,'eee','eee','2000-02-02 09:00:00');
insert into list_test values (6,13,'fff','fff','2000-02-03 09:00:00');
insert into list_test values (7,21,'ggg','ggg','2000-03-01 09:00:00');
insert into list_test values (8,22,'hhh','hhh','2000-03-02 09:00:00');
insert into list_test values (9,23,'iii','iii','2000-03-03 09:00:00');
insert into list_test values (10,31,'jjj','jjj','2000-04-01 09:00:00');

ALTER TABLE list_test REORGANIZE PARTITION p1,p2 INTO ( 
PARTITION p3 VALUES IN (11,12,21,22));

select * from db_partition where class_name = 'list_test' order by partition_name;

insert into list_test values (11,13,'ggg','ggg','2000-05-01 09:00:00');
insert into list_test values (12,31,'eee','eee','2000-05-02 09:00:00');

select * from list_test order by id;
select * from list_test__p__p0 order by 1,2;
select * from list_test__p__p3 order by 1,2;

drop table list_test;
