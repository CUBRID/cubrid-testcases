drop table if exists tbl;
create table tbl(col1 int, col2 int, col3 int);
insert into tbl(col1) values (1),(2),(3);
CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i double) RETURN double as language java name 'SpTest7.typetestdouble1(double) return double';

select col1, decode(col1,test_fc(1),'1',test_fc(2),'2',test_fc(3),'3') from tbl;
select col1, decode(col1, 1, test_fc(1), 2, test_fc2(1.2), test_fc2(1.234)) FROM tbl;

select col1, IF(col1=test_fc(1), 'one', 'other') from tbl;
select col1, IF(col1=1, test_fc2(1), test_fc2(1.234)) from tbl;

drop function test_fc;
drop function test_fc2;
drop table if exists tbl;
