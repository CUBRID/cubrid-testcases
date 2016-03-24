autocommit off;
create table test_to_date_table(
    c1 varchar(500),
    c2 varchar(500),
    c3 varchar(500),
    c4 varchar(500)
);
insert into test_to_date_table (c1,c2,c3) values('1976 09 06 11:11:11 ','yyyy mm dd hh:mm:ss','9/6/1976');

SELECT c1,c2, to_date( c1,c2) FROM test_to_date_table;
SELECT c4, to_date( c4) FROM test_to_date_table;
SELECT c1,c4, to_date( c1,c4) FROM test_to_date_table;
SELECT c4,c2, to_date( c4,c2) FROM test_to_date_table;
SELECT c4,c4, to_date( c4,c4) FROM test_to_date_table;
drop table test_to_date_table;
rollback;
