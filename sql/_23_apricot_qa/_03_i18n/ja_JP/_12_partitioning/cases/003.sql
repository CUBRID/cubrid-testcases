--+ holdcas on;
set names utf8;
create table list_test(id int not null primary key ,
			test_char char(50)collate utf8_ja_exp,
			test_varchar varchar(2000)collate utf8_ja_exp,
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50)collate utf8_ja_exp,
			test_nvarchar nchar varying(2000)collate utf8_ja_exp,
			test_string string collate utf8_ja_exp,
			test_time time)
PARTITION BY LIST (test_time) (
    PARTITION p0 VALUES IN ('06:00:00 ��ǰ','07:00:00 ��ǰ','09:00:00 ��ǰ'),
	PARTITION p1 VALUES IN ('06:00:00 ����','07:00:00 ����','09:00:00 ����')
);

select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_n��ǰe like 'list%' order by 1;


drop table list_test;
set names utf8;
commit;
--+ holdcas off;

