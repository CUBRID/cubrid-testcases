--Test the constraint of the foreign key using delete cascade and update no action with parition table(delete parition table)
--it tests Test the constraint of the foreign key syntax using delete cascade and update no action with parition table,delete parition table

create table range_test(id int ,
			test_int int,
			test_char char(50) primary key ,
			test_varchar varchar(2000),
			test_datetime timestamp)
PARTITION BY RANGE (test_char) (
    PARTITION p0 VALUES LESS THAN ('ddd'),
    PARTITION p1 VALUES LESS THAN ('ggg'),
    PARTITION p2 VALUES LESS THAN ('kkk'),
    PARTITION p7 VALUES LESS THAN MAXVALUE
);


insert into range_test values (1,1,'aaa','aaa','2000-01-01 09:00:00');
insert into range_test values (2,2,'bbb','bbb','2000-01-02 09:00:00');
insert into range_test values (3,3,'ccc','ccc','2000-01-03 09:00:00');
insert into range_test values (4,11,'ddd','ddd','2000-02-01 09:00:00');
insert into range_test values (5,12,'eee','eee','2000-02-02 09:00:00');
insert into range_test values (6,13,'fff','fff','2000-02-03 09:00:00');
insert into range_test values (7,21,'ggg','ggg','2000-03-01 09:00:00');
insert into range_test values (8,22,'hhh','hhh','2000-03-02 09:00:00');
insert into range_test values (9,23,'iii','iii','2000-03-03 09:00:00');
insert into range_test values (10,31,'jjj','jjj','2000-04-01 09:00:00');


create table comment (id int primary key,
		      name char(10),
		      post_id char(50) foreign key references range_test on delete cascade on update no action 
);

insert into comment values (1, '111','aaa');
insert into comment values (2, '222','aaa');
insert into comment values (3, '333','ccc');
insert into comment values (4, '444','eee');
insert into comment values (5, '555','hhh');
insert into comment values (6, '666','iii');

delete from range_test where test_char = 'eee';

select * from range_test order by id;

select * from range_test__p__p0 order by id;
select * from range_test__p__p1 order by id;
select * from range_test__p__p2 order by id;
select * from range_test__p__p7 order by id;

select * from comment order by id;

drop table comment;
drop table range_test;
