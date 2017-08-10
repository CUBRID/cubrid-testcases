--+ holdcas on;
set names utf8;
create table list_test(id int,	
			test_time time,
			test_date date,
			test_timestamp timestamp,
            primary key(id, test_timestamp))
	PARTITION BY LIST (test_timestamp) (
	PARTITION p0 VALUES IN ('2011-05-01 10:11:12','2011-05-02 10:11:12','2011-05-03 10:11:12'),
	PARTITION p1 VALUES IN ('2006-01-01 09:00:00','2006-02-01 09:00:00','2006-03-01 09:00:00')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;
