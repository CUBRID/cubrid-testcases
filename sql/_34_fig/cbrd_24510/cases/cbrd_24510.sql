-- This test case verifies CBRD-24510 issue.
-- Create, insert, and delete tables including indexes.
-- If you call the MIN and MAX functions of the index column, the result is strange.

drop table if exists test_tbl; 
create table test_tbl ( col1 int, col2 int, col3 int, primary key(col1) );
insert into test_tbl values(1,2,3),(2,3,4), (5,6,7);

select count(*), min(col1), max(col1) from test_tbl;

delete from test_tbl;

select count(*), min(col1), max(col1) from test_tbl;

drop table test_tbl;

