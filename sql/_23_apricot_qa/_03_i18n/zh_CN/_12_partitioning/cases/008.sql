--+ holdcas on;
set names utf8;
create table hash_test(id int,
			  test_char CHAR(50) collate utf8_gen,
			  test_varchar VARCHAR(2000) collate utf8_gen, 
			  test_string STRING collate utf8_gen,           
			  test_datetime timestamp, 
              primary key(id, test_varchar))           
	PARTITION BY HASH(test_varchar)
        PARTITIONS 4;
    insert into hash_test values(1,'你你你','你你你','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(2,'a啊ǎ','a啊ǎ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(3,'ccc','ccc','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(4,'a啊ǎ','a啊ǎ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(5,'呵呵呵','呵呵呵','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(6,'ǎǎǎ','ǎǎǎ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(7,'aaa','aaa','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(8,'111','111','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(9,'爸爸爸','爸爸爸','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(10,'一一一','一一一','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(11,'222','222','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(12,'lll','lll','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(13,'在在在','在在在','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(14,'再再再','再再再','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(15,'999','999','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(16,'ǗǗǗ','ǗǗǗ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(17,'七七七','七七七','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(18,'人人人','人人人','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(19,'民民民','民民民','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(20,'币币币','币币币','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test values(21,NULL,NULL,NULL,'2006-03-01 09:00:00');
	
	    
create table hash_test2(id int not null primary key ,
			  test_char CHAR(50) collate utf8_gen,
			  test_varchar VARCHAR(2000) collate utf8_gen,
			  test_string STRING collate utf8_gen,           
			  test_datetime timestamp) ;
	insert into hash_test2 values(1,'你你你','你你你','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(2,'a啊ǎ','a啊ǎ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(3,'ccc','ccc','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(4,'a啊ǎ','a啊ǎ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(5,'呵呵呵','呵呵呵','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(6,'ǎǎǎ','ǎǎǎ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(7,'aaa','aaa','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(8,'111','111','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(9,'爸爸爸','爸爸爸','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(10,'一一一','一一一','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(11,'222','222','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(12,'lll','lll','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(13,'在在在','在在在','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(14,'再再再','再再再','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(15,'999','999','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(16,'ǗǗǗ','ǗǗǗ','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(17,'七七七','七七七','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(18,'人人人','人人人','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(19,'民民民','民民民','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(20,'币币币','币币币','a啊ǎ呵爸一12在再','2006-03-01 09:00:00');
	insert into hash_test2 values(21,NULL,NULL,NULL,'2006-03-01 09:00:00');	
	update hash_test set test_varchar = (select test_varchar from hash_test2 where  id = 8) where test_varchar = '你你你';
	update hash_test set test_varchar = (select test_varchar from hash_test2 where  id = 10) where test_varchar = '呵呵呵'   ;
select * from hash_test order by id;
select * from hash_test__p__p0 order by id;
select * from hash_test__p__p1 order by id;
select * from hash_test__p__p2 order by id;
select * from hash_test__p__p3 order by id;



drop table hash_test;
drop table hash_test2;
set names iso88591;
commit;
--+ holdcas off;
