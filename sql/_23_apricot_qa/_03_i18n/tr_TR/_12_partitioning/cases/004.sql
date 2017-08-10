--+ holdcas on;
set names utf8;
create table list_test(id int,	
			test_time time,
			test_date date,
			test_timestamp timestamp,
            primary key(id, test_date))
	PARTITION BY LIST (test_date) (
	PARTITION p0 VALUES IN ('2011-05-01 PAZAR','2011-05-02 PAZARTESİ','2011-05-03 SALI')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;



