autocommit off;
set names utf8;
create table test_replace(
			replace_1_1_k varchar(50) charset utf8,
			replace_1_1_e varchar(50) charset utf8,
			replace_1_2_1_k varchar(50) charset utf8,
			replace_1_2_1_e varchar(50) charset utf8,
			replace_1_2_2_k varchar(50) charset utf8,
			replace_1_2_2_e varchar(50) charset utf8,
			replace_2_1_k varchar(50) charset utf8,
			replace_2_1_e varchar(50) charset utf8,
			replace_2_2_k varchar(50) charset utf8,
			replace_2_2_e varchar(50) charset utf8,
			replace_2_3_k varchar(50) charset utf8,
			replace_2_3_e varchar(50) charset utf8
);
insert into test_replace (replace_1_1_k,replace_1_1_e,replace_1_2_1_k,replace_1_2_1_e,replace_1_2_2_k,replace_1_2_2_e,replace_2_1_k,replace_2_1_e,replace_2_2_k,replace_2_2_e,replace_2_3_k,replace_2_3_e) values ('얼렐레','ebebe ','에베베','ebebe','베베베','bebebe','얼레레','abade','얼레레','abcdc','얼렐레렐레','abcdecd');
			select replace('얼렐레','얼') from test_replace;
			select replace('abcde','a') from test_replace;
			select replace(replace_1_1_k,'얼') from test_replace;
			select replace(replace_1_1_e,'a') from test_replace;
			select replace('얼렐레','렐') from test_replace;
			select replace('abcde','c') from test_replace;
			select replace(replace_1_1_k,'렐') from test_replace;
			select replace(replace_1_1_e,'c') from test_replace;
			select replace('얼렐레','레') from test_replace;
			select replace('abcde','e') from test_replace;
			select replace(replace_1_1_k,'레') from test_replace;
			select replace(replace_1_1_e,'e') from test_replace;
			select replace('얼렐레','얼렐레') from test_replace;
			select replace('abcde','abcde') from test_replace;
			select replace(replace_1_1_k,'얼렐레') from test_replace;
			select replace(replace_1_1_e,'abcde') from test_replace;
			select replace('에베베','베') from test_replace;
			select replace('ebebe','eb') from test_replace;
			select replace(replace_1_2_1_k,'베')from test_replace;
			select replace(replace_1_2_1_e,'eb') from test_replace;
			select replace('베베베','베') from test_replace;
			select replace('bebebe','be') from test_replace;
			select replace(replace_1_2_2_k,'베')from test_replace;
			select replace(replace_1_2_2_e,'eb') from test_replace;
			select replace('얼렐레','얼','어얼') from test_replace;
			select replace('얼렐레','얼','earl') from test_replace;
			select replace('abcde','a','xyz') from test_replace;
			select replace('abcde','a','에') from test_replace;
			select replace(replace_1_1_k,'얼','어얼') from test_replace;
			select replace(replace_1_1_k,'얼','earl') from test_replace;
			select replace(replace_1_1_e,'a','xyz') from test_replace;
			select replace(replace_1_1_e,'a','에') from test_replace;
			select replace('얼렐레','렐','룰') from test_replace;
			select replace('얼렐레','렐','u') from test_replace;
			select replace('abcde','c','f') from test_replace;
			select replace('abcde','a','에') from test_replace;
			select replace(replace_1_1_k,'렐','룰') from test_replace;
			select replace(replace_1_1_k,'렐','u') from test_replace;
			select replace(replace_1_1_e,'c','f') from test_replace;
			select replace(replace_1_1_e,'a','에') from test_replace;
			select replace('얼렐레','렐레','레') from test_replace;
			select replace('얼렐레','렐레','le') from test_replace;
			select replace('abcde','cde','f') from test_replace;
			select replace('abcde','cde','에') from test_replace;
			select replace(replace_1_1_k,'렐레','레') from test_replace;
			select replace(replace_1_1_k,'렐레','le') from test_replace;
			select replace(replace_1_1_e,'cde','f')from test_replace;
			select replace(replace_1_1_e,'cde','에') from test_replace;
			select replace('얼레레','레','그레이') from test_replace;
			select replace('얼레레','레','gray') from test_replace;
			select replace('abade','a','xyz') from test_replace;
			select replace('abade','a','에') from test_replace;
			select replace(replace_2_1_k,'레','그레이') from test_replace;
			select replace(replace_2_1_k,'레','gray') from test_replace;
			select replace(replace_2_1_e,'a','xyz')from test_replace;
			select replace(replace_2_1_e,'a','에') from test_replace;
			select replace('얼레레','레','룰') from test_replace;
			select replace('얼레레','레','u') from test_replace;
			select replace('abcdc','c','f') from test_replace;
			select replace('abcdc','c','에') from test_replace;
			select replace(replace_2_2_k,'레','룰') from test_replace;
			select replace(replace_2_2_k,'레','u') from test_replace;
			select replace(replace_2_2_e,'c','f')from test_replace;
			select replace(replace_2_2_e,'레','u') from test_replace;
			select replace('얼렐레렐레','렐레','레') from test_replace;
			select replace('얼렐레렐레','렐레','le') from test_replace;
			select replace('abcdecd','cd','f') from test_replace;
			select replace('abcdefcde','cde','에') from test_replace;
			select replace(replace_2_3_k,'렐레','레') from test_replace;
			select replace(replace_2_3_k,'렐레','le')from test_replace;
			select replace(replace_2_3_e,'cd','f')from test_replace;
			select replace(replace_2_3_e,'cde','에') from test_replace;
create table test_replace_table(
	c1 varchar(50) charset utf8,
	c2 varchar(50) charset utf8,
	c3 varchar(50) charset utf8,
	c4 varchar(50) charset utf8,
	c5 varchar(50) charset utf8
);
insert into test_replace_table (c1,c2,c3) values('최공훈이  ','최','최c');
			SELECT c1,'최', replace(c1,'최') FROM test_replace_table;
			SELECT '최공훈이  ',c2, replace('최공훈이  ',c2) FROM test_replace_table;
			SELECT c1, c2, replace(c1,c2) FROM test_replace_table;
			SELECT c1,'최',c3, replace(c1,'최',c3) FROM test_replace_table;
			SELECT '최공훈이  ',c2,c3, replace('최공훈이  ',c2,c3) FROM test_replace_table;
			SELECT c1,c2,'최c', replace(c1,c2,'최c') FROM test_replace_table;
			SELECT '최공훈이  ','최',c3, replace( '최공훈이  ','최',c3) FROM test_replace_table;
			SELECT '최공훈이  ',c2,'최c', replace( '최공훈이  ',c2,'최c') FROM test_replace_table;
			SELECT c1,'최','최c', replace( c1,'최','최c') FROM test_replace_table;
			SELECT c1,c2,c3, replace( c1,c2,c3) FROM test_replace_table;
			select replace('','a','c') FROM test_replace;
			select replace('a','','c') FROM test_replace;
			select replace('a','c','') FROM test_replace;
			SELECT c5,'최', replace( c5,'최') FROM test_replace_table;
			SELECT '최공훈이  ',c4, replace( '최공훈이  ',c4) FROM test_replace_table;
			SELECT c5,c4, replace( c5,c4) FROM test_replace_table;
			SELECT c5,'최',c5, replace( c5,'최',c5) FROM test_replace_table;
			SELECT '최공훈이  ',c4,c5, replace( '최공훈이  ',c4,c5) FROM test_replace_table;
			SELECT c5,c4,'최c', replace( c5,c4,'최c') FROM test_replace_table;
			SELECT '최공훈이  ','최',c5, replace( '최공훈이  ','최',c5) FROM test_replace_table;
			SELECT '최공훈이  ',c4,'최c', replace( '최공훈이  ',c4,'최c') FROM test_replace_table;
			SELECT c5,'최','최c', replace( c5,'최','최c') FROM test_replace_table;
			SELECT c5,c5,c5,replace( c5,c5,c5) FROM test_replace_table;
			select replace(NULL,NULL) from test_replace;
			select replace(NULL,NULL,NULL) from test_replace;
drop table test_replace;
drop table test_replace_table;
set names iso88591;
rollback;
