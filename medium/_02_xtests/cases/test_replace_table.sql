autocommit off;
set names utf8;
create table test_replace_table(
    c1 varchar(50),
    c2 varchar(50),
    c3 varchar(50),
    c4 varchar(50),
	c5 varchar(50)
) charset euckr;
insert into test_replace_table (c1,c2,c3) values('최공훈이  ','최','최c');
SELECT '최공훈이  ',c2, replace('최공훈이  ',c2) FROM test_replace_table;
SELECT c1,'최', replace(c1,'최') FROM test_replace_table;
SELECT c1, c2, replace(c1,c2) FROM test_replace_table;
SELECT '최공훈이  ',c2,c3, replace('최공훈이  ',c2,c3) FROM test_replace_table;
SELECT c1,'최',c3, replace(c1,'최',c3) FROM test_replace_table;
SELECT c1,c2,'최c', replace(c1,c2,'최c') FROM test_replace_table;
SELECT '최공훈이  ','최',c3, replace( '최공훈이  ','최',c3) FROM test_replace_table;
SELECT '최공훈이  ',c2,'최c', replace( '최공훈이  ',c2,'최c') FROM test_replace_table;
SELECT c1,'최','최c', replace( c1,'최','최c') FROM test_replace_table;
SELECT c1,c2,c3, replace( c1,c2,c3) FROM test_replace_table;
SELECT '최공훈이  ',c4, replace( '최공훈이  ',c4) FROM test_replace_table;
SELECT c5,'최', replace( c5,'최') FROM test_replace_table;
SELECT c5,c4, replace( c5,c4) FROM test_replace_table;
SELECT '최공훈이  ','최',c5, replace( '최공훈이  ','최',c5) FROM test_replace_table;
SELECT '최공훈이  ',c4,'최c', replace( '최공훈이  ',c4,'최c') FROM test_replace_table;
SELECT c5,'최','최c', replace( c5,'최','최c') FROM test_replace_table;
SELECT '최공훈이  ',c4,c5, replace( '최공훈이  ',c4,c5) FROM test_replace_table;
SELECT c5,'최',c5, replace( c5,'최',c5) FROM test_replace_table;
SELECT c5,c4,'최c', replace( c5,c4,'최c') FROM test_replace_table;
SELECT c5,c4,c5, replace( c5,c4,c5) FROM test_replace_table;
drop table test_replace_table;
set names iso88591;
rollback;
