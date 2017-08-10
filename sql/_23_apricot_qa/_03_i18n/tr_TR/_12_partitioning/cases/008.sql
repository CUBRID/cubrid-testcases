--+ holdcas on;
set names utf8;
create table hash_test(id int,
			  test_char char(50) collate utf8_tr_cs,
			  test_varchar varchar(2000) collate utf8_tr_cs,
			  test_bit bit(16),           
			  test_varbit bit varying(20),       
			  test_nchar nchar(50) collate utf8_tr_cs,           
			  test_nvarchar nchar varying(2000) collate utf8_tr_cs, 
			  test_string string collate binary,           
			  test_datetime timestamp,
              primary key(id, test_varchar))           
	PARTITION BY HASH(test_varchar)
        PARTITIONS 4;
       	insert into hash_test values(1,'你你你','你你你',B'100',B'1011',N'你你你',N'你你你','你你你你你你你你你你','2006-03-01 09:00:00');
	insert into hash_test values(2,'ççç','ççç',B'100',B'1100',N'ççç',N'ççç','çççççççççç','2006-03-01 09:00:00');
	insert into hash_test values(3,'ccc','ccc',B'100',B'1110',N'ccc',N'ccc','cccccccccc','2006-03-01 09:00:00');
	insert into hash_test values(4,'ÇÇÇ','ÇÇÇ',B'100',B'1110',N'ÇÇÇ',N'ÇÇÇ','ÇÇÇÇÇÇÇÇÇÇ','2006-03-01 09:00:00');
	insert into hash_test values(5,'ĞĞĞ','ĞĞĞ',B'101',B'1111',N'ĞĞĞ',N'ĞĞĞ','ĞĞĞĞĞĞĞĞĞĞ','2006-03-01 09:00:00');
	insert into hash_test values(6,'ğğğ','ğğğ',B'101',B'1111',N'ğğğ',N'ğğğ','ğğğğğğğğğğ','2006-03-01 09:00:00');
	insert into hash_test values(7,'ggg','ggg',B'101',B'1111',N'ggg',N'ggg','gggggggggg','2006-03-01 09:00:00');
	insert into hash_test values(8,'İİİ','İİİ',B'101',B'1111',N'İİİ',N'İİİ','İİİİİİİİİİ','2006-03-01 09:00:00');
	insert into hash_test values(9,'iii','iii',B'101',B'1111',N'iii',N'iii','iiiiiiiiii','2006-03-01 09:00:00');
	insert into hash_test values(10,'ııı','ııı',B'101',B'1111',N'ııı',N'ııı','ıııııııııı','2006-03-01 09:00:00');
	insert into hash_test values(11,'kkk','kkk',B'100',B'1011',N'kkk',N'kkk','kkkkkkkkkk','2006-03-01 09:00:00');
	insert into hash_test values(12,'lll','lll',B'100',B'1100',N'lll',N'lll','llllllllll','2006-03-01 09:00:00');
	insert into hash_test values(13,'mmm','mmm',B'100',B'1110',N'mmm',N'mmm','mmmmmmmmmm','2006-03-01 09:00:00');
	insert into hash_test values(14,'nnn','nnn',B'100',B'1110',N'nnn',N'nnn','nnnnnnnnnn','2006-03-01 09:00:00');
	insert into hash_test values(15,'ooo','ooo',B'101',B'1111',N'ooo',N'ooo','oooooooooo','2006-03-01 09:00:00');
	insert into hash_test values(16,'ÖÖÖ','ÖÖÖ',B'101',B'1111',N'ÖÖÖ',N'ÖÖÖ','ÖÖÖÖÖÖÖÖÖÖ','2006-03-01 09:00:00');
	insert into hash_test values(17,'qqq','qqq',B'101',B'1111',N'qqq',N'qqq','qqqqqqqqqq','2006-03-01 09:00:00');
	insert into hash_test values(18,'ööö','ööö',B'101',B'1111',N'ööö',N'ööö','ööööööööör','2006-03-01 09:00:00');
	insert into hash_test values(19,'sss','sss',B'101',B'1111',N'sss',N'sss','ssssssssss','2006-03-01 09:00:00');
	insert into hash_test values(20,'ttt','ttt',B'101',B'1111',N'ttt',N'ttt','tttttttttt','2006-03-01 09:00:00');
	insert into hash_test values(21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
	
	    
create table hash_test2(id int not null primary key ,
			  test_char char(50) collate utf8_tr_cs,
			  test_varchar varchar(2000) collate utf8_tr_cs,
			  test_bit bit(16),           
			  test_varbit bit varying(20),       
			  test_nchar nchar(50) collate utf8_tr_cs,           
			  test_nvarchar nchar varying(2000) collate utf8_tr_cs, 
			  test_string string collate binary,           
			  test_datetime timestamp) ;
		insert into hash_test2 values(1,'你你你','你你你',B'100',B'1011',N'你你你',N'你你你','你你你你你你你你你a','2006-03-01 09:00:00');
	insert into hash_test2 values(2,'ççç','ççç',B'100',B'1100',N'ççç',N'ççç','çççççççççb','2006-03-01 09:00:00');
	insert into hash_test2 values(3,'ccc','ccc',B'100',B'1110',N'ccc',N'ccc','cccccccccc','2006-03-01 09:00:00');
	insert into hash_test2 values(4,'ÇÇÇ','ÇÇÇ',B'100',B'1110',N'ÇÇÇ',N'ÇÇÇ','ÇÇÇÇÇÇÇÇÇd','2006-03-01 09:00:00');
	insert into hash_test2 values(5,'ĞĞĞ','ĞĞĞ',B'101',B'1111',N'ĞĞĞ',N'ĞĞĞ','ĞĞĞĞĞĞĞĞĞe','2006-03-01 09:00:00');
	insert into hash_test2 values(6,'ğğğ','ğğğ',B'101',B'1111',N'ğğğ',N'ğğğ','ğğğğğğğğğf','2006-03-01 09:00:00');
	insert into hash_test2 values(7,'ggg','ggg',B'101',B'1111',N'ggg',N'ggg','gggggggggg','2006-03-01 09:00:00');
	insert into hash_test2 values(8,'İİİ','İİİ',B'101',B'1111',N'İİİ',N'İİİ','İİİİİİİİİh','2006-03-01 09:00:00');
	insert into hash_test2 values(9,'iii','iii',B'101',B'1111',N'iii',N'iii','iiiiiiiiii','2006-03-01 09:00:00');
	insert into hash_test2 values(10,'ııı','ııı',B'101',B'1111',N'ııı',N'ııı','ıııııııııj','2006-03-01 09:00:00');
	insert into hash_test2 values(11,'kkk','kkk',B'100',B'1011',N'kkk',N'kkk','kkkkkkkkkk','2006-03-01 09:00:00');
	insert into hash_test2 values(12,'lll','lll',B'100',B'1100',N'lll',N'lll','llllllllll','2006-03-01 09:00:00');
	insert into hash_test2 values(13,'mmm','mmm',B'100',B'1110',N'mmm',N'mmm','mmmmmmmmmm','2006-03-01 09:00:00');
	insert into hash_test2 values(14,'nnn','nnn',B'100',B'1110',N'nnn',N'nnn','nnnnnnnnnn','2006-03-01 09:00:00');
	insert into hash_test2 values(15,'ooo','ooo',B'101',B'1111',N'ooo',N'ooo','oooooooooo','2006-03-01 09:00:00');
	insert into hash_test2 values(16,'ÖÖÖ','ÖÖÖ',B'101',B'1111',N'ÖÖÖ',N'ÖÖÖ','ÖÖÖÖÖÖÖÖÖp','2006-03-01 09:00:00');
	insert into hash_test2 values(17,'qqq','qqq',B'101',B'1111',N'qqq',N'qqq','qqqqqqqqqq','2006-03-01 09:00:00');
	insert into hash_test2 values(18,'ööö','ööö',B'101',B'1111',N'ööö',N'ööö','ööööööööör','2006-03-01 09:00:00');
	insert into hash_test2 values(19,'sss','sss',B'101',B'1111',N'sss',N'sss','ssssssssss','2006-03-01 09:00:00');
	insert into hash_test2 values(20,'ttt','ttt',B'101',B'1111',N'ttt',N'ttt','tttttttttt','2006-03-01 09:00:00');
	insert into hash_test2 values(21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');	
	update hash_test set test_varchar = (select test_varchar from hash_test2 where  id = 8) where test_varchar = '你你你';
	update hash_test set test_varchar = (select test_varchar from hash_test2 where  id = 10) where test_varchar = 'ğğğ'   ;
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
