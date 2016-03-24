autocommit off;
set names utf8;
create table test_to_char_table(
    d1 timestamp,
    c2 varchar(500),
    d3 timestamp,
    c4 varchar(500)
);
insert into test_to_char_table (d1,c2) values(TIMESTAMP '10:30:20 9/6/1976','cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text" "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"');
SELECT d1, to_char( d1) FROM test_to_char_table;
SELECT d1,'cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text" "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"', to_char( d1,'cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text" "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"') FROM test_to_char_table;
SELECT TIMESTAMP '10:30:20 9/6/1976',c2, to_char( TIMESTAMP '10:30:20 9/6/1976',c2) FROM test_to_char_table;
SELECT d1,c2, to_char( d1,c2) FROM test_to_char_table;
SELECT d3, to_char( d3) FROM test_to_char_table;
SELECT d1,c4, to_char( d1,c4) FROM test_to_char_table;
SELECT d3,c2, to_char( d3,c2) FROM test_to_char_table;
SELECT d3,c4, to_char( d3,c4) FROM test_to_char_table;
drop table test_to_char_table;
rollback;
