autocommit off;
set names utf8;
create table test_to_time_table(
    c1 varchar(500),
    c2 varchar(500),
    c3 varchar(500),
    c4 varchar(500)
) charset utf8 ;
insert into test_to_time_table (c1,c2,c3) values('12시 30분 20초 pm','HH"시" MI"분" SS"초" a.m.','12:30:20 pm');
SELECT c3, to_time( c3) FROM test_to_time_table;
SELECT c1,'HH"시" MI"분" SS"초" a.m.', to_time(  cast (c1 as string charset utf8),'HH"시" MI"분" SS"초" a.m.') FROM test_to_time_table;
SELECT '12시 30분 20초 pm',c2, to_time( '12시 30분 20초 pm',c2) FROM test_to_time_table;
SELECT c1,c2, to_time( c1,c2) FROM test_to_time_table;
SELECT c4, to_time( c4) FROM test_to_time_table;
SELECT c1,c4, to_time( c1,c4) FROM test_to_time_table;
SELECT c4,c2, to_time( c4,c2) FROM test_to_time_table;
SELECT c4,c4, to_time( c4,c4) FROM test_to_time_table;
drop table test_to_time_table;
rollback;
set names iso88591;