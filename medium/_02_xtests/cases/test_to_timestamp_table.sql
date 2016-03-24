autocommit off;
set names utf8;
create table test_to_timestamp_table(
    c1 varchar(500) charset utf8,
    c2 varchar(500) charset utf8,
    c3 varchar(500) charset utf8,
    c4 varchar(500) charset utf8
);
insert into test_to_timestamp_table (c1,c2,c3) values('16년 September 6일 10시 20분 31초 pm','yy"년" Month dd"일" hh"시" mi"분" ss"초"pm','12:30:20 pm 9/6/1976');
SELECT c3, to_timestamp( c3) FROM test_to_timestamp_table;
SELECT c1,'yy"년" Month dd"일" hh"시" mi"분" ss"초"pm', to_timestamp( c1,'yy"년" Month dd"일" hh"시" mi"분" ss"초"pm') FROM test_to_timestamp_table;
SELECT '16년 September 6일 10시 20분 31초 pm',c2, to_timestamp( '16년 September 6일 10시 20분 31초 pm',c2) FROM test_to_timestamp_table;
SELECT c1,c2, to_timestamp( c1,c2) FROM test_to_timestamp_table;
SELECT c4, to_timestamp( c4) FROM test_to_timestamp_table;
SELECT c1,c4, to_timestamp( c1,c4) FROM test_to_timestamp_table;
SELECT c4,c2, to_timestamp( c4,c2) FROM test_to_timestamp_table;
SELECT c4,c4, to_timestamp( c4,c4) FROM test_to_timestamp_table;
drop table test_to_timestamp_table;
set names iso88591;
rollback;
