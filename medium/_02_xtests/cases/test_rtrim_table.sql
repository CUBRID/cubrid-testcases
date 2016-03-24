autocommit off;
set names utf8;
create table test_rtrim_table(
    c1 varchar(50),
    c2 varchar(50),
    c3 varchar(50)
) charset euckr;
insert into test_rtrim_table (c1,c2) values(' 최 최공훈 ',' 훈');
SELECT c1, RTRIM( c1) FROM test_rtrim_table;
SELECT c1,' 훈', RTRIM( c1,' 훈') FROM test_rtrim_table;
SELECT ' 최 최공훈 ',c2, RTRIM( ' 최 최공훈 ',c2) FROM test_rtrim_table;
SELECT c1,c2, RTRIM( c1,c2) FROM test_rtrim_table;
SELECT c3, RTRIM( c3) FROM test_rtrim_table;
SELECT c1,c3, RTRIM( c1,c3) FROM test_rtrim_table;
SELECT c3,c2, RTRIM( c3,c2) FROM test_rtrim_table;
SELECT c3,c3, RTRIM( c3,c3) FROM test_rtrim_table;
drop table test_rtrim_table;
set names iso88591;
rollback;
