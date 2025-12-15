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

select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names utf8;
commit;
--+ holdcas off;
