--This is a test case to test the operation of setting the initial value with the result value of the javasp function by using Default when creating a table.

--(with parameters) success.
CREATE OR REPLACE FUNCTION test_fc(i int) RETURN string as language java name 'SpTest.testInt(int) return int';
CREATE TABLE test_tbl(col1 varchar(200) DEFAULT test_fc(1), col2 varchar(100)); 
insert into test_tbl(col2) values ('1234');
select * from test_tbl;

--(no parameters) fail.
CREATE OR REPLACE FUNCTION test_fc2() RETURN int as language java name 'SpTest.testInt10() return int';
CREATE TABLE test_tbl2(col1 int DEFAULT test_fc2());

--javasp function using db connection. success.  ((no actual connection))
CREATE OR REPLACE FUNCTION test_fc3(test_ip string, test_port string, db_name string, test_user string, test_tbl string) RETURN int as language java name 'SpTest.IssueCount(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String) return int';
select test_fc3('test_ip','test_port','db_name','test_user','test_tbl');
CREATE TABLE test_tbl3(col1 int DEFAULT test_fc3('test_ip','test_port','db_name','test_user','test_tbl'));
select * from test_tbl3;

drop FUNCTION test_fc;
drop FUNCTION test_fc2;
drop FUNCTION test_fc3;
drop table if exists test_tbl;
drop table if exists test_tbl2;
drop table if exists test_tbl3;

