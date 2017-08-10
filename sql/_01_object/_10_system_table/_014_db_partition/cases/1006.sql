--Create partition  with char type and retrieve infomation from db_partition
create table list_test(id int not null ,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp,
                        primary key(id,test_char))
PARTITION BY LIST (test_char) (
    PARTITION p0 VALUES IN ('aaa','bbb','ddd')
);

select * from db_class where class_name like 'list%'  order by 1,2,3;
select * from db_partition
where class_name='list_test'  order by 1,2,3;

drop table list_test;
