--+ holdcas on;
set names utf8;
create table hash_test(id int,
			  test_char char(50) collate utf8_ja_exp,
			  test_varchar varchar(2000) collate utf8_ja_exp, 
			  test_string string collate utf8_ja_exp,           
			  test_datetime timestamp,
              primary key(id, test_varchar))          
	PARTITION BY HASH(test_varchar)
        PARTITIONS 4;
    insert into hash_test values(1,'チチチ','チチチ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(2,'a唖ǎ','a唖ǎ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(3,'ccc','ccc','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(4,'a唖ǎ','a唖ǎ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(5,'唖唖唖','唖唖唖','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(6,'ぁぁぁ','ぁぁぁ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(7,'アアア','アアア','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(8,'いいい','いいい','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(9,'ぅぅぅ','ぅぅぅ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(10,'かかか','かかか','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(11,'どどど','どどど','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(12,'曜曜曜','曜曜曜','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(13,'ンンン','ンンン','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(14,'レレレ','レレレ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(15,'亜亜亜','亜亜亜','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(16,'愛愛愛','愛愛愛','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(17,'応応応','応応応','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(18,'凩凩凩','凩凩凩','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(19,'■■■','■■■','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(20,'。。。','。。。','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test values(21,NULL,NULL,NULL,'2006-03-01 09:00:00');
	
	    
create table hash_test2(id int not null primary key ,
			  test_char char(50),
			  test_varchar varchar(2000) charset binary,
			  test_string string,           
			  test_datetime timestamp) ;
	insert into hash_test2 values(1,'チチチ','チチチ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(2,'a唖ǎ','a唖ǎ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(3,'ccc','ccc','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(4,'a唖ǎ','a唖ǎ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(5,'唖唖唖','唖唖唖','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(6,'ぁぁぁ','ぁぁぁ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(7,'アアア','アアア','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(8,'いいい','いいい','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(9,'ぅぅぅ','ぅぅぅ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(10,'かかか','かかか','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(11,'どどど','どどど','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(12,'曜曜曜','曜曜曜','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(13,'ンンン','ンンン','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(14,'レレレ','レレレ','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(15,'亜亜亜','亜亜亜','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(16,'愛愛愛','愛愛愛','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(17,'応応応','応応応','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(18,'凩凩凩','凩凩凩','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(19,'■■■','■■■','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(20,'。。。','。。。','a唖ǎ西暦けげこご','2006-03-01 09:00:00');
	insert into hash_test2 values(21,NULL,NULL,NULL,'2006-03-01 09:00:00');	
	update hash_test set test_varchar = (select test_varchar from hash_test2 where  id = 8) where test_varchar = 'チチチ';
	update hash_test set test_varchar = (select test_varchar from hash_test2 where  id = 10) where test_varchar = '唖唖唖'   ;
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
