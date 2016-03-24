autocommit off;
set names utf8;
create table test_ltrim_table(
    c1 varchar(50),
    c2 varchar(50),
    c3 varchar(50)
) charset euckr;
insert into test_ltrim_table (c1,c2) values(' 최 최공훈 ',' 최');
SELECT c1, LTRIM(c1) FROM test_ltrim_table;
SELECT c1, ' 최', LTRIM(c1,' 최') FROM test_ltrim_table;
SELECT ' 최 최공훈 ',c2, LTRIM(' 최 최공훈 ',c2) FROM test_ltrim_table;
SELECT c1, c2, LTRIM(c1,c2) FROM test_ltrim_table;
SELECT c3, LTRIM(c3) FROM test_ltrim_table;
SELECT c1, c3, LTRIM(c1,c3) FROM test_ltrim_table;
SELECT c3, c2, LTRIM(c3,c2) FROM test_ltrim_table;
SELECT c3, c3, LTRIM(c3,c3) FROM test_ltrim_table;
drop table test_ltrim_table;
set names iso88591;
rollback;
