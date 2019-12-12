drop table if exists list_test;

create table list_test(id int not null, test_int int, test_char char(50), test_varchar varchar(2000), test_datetime timestamp,primary key(id,test_char)) PARTITION BY LIST (test_char) (PARTITION p0 VALUES IN ('aaa','bbb','ccc','ddd'), PARTITION p1 VALUES IN ('eee','fff','ggg','hhh',null), PARTITION p2 VALUES IN ('iii','jjj'));

alter table list_test add column i int;

drop table list_test;
