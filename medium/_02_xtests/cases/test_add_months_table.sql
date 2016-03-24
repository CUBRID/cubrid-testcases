autocommit off;
create table test_add_months_table(
    c1 date,
    i2 integer,
    c3 date,
    i4 integer
);
insert into test_add_months_table (c1,i2) values(date '9/6/1976',100);
SELECT c1, 100, add_months(c1,100) FROM test_add_months_table;
SELECT date '9/6/1976', i2, add_months(date '9/6/1976',i2) FROM test_add_months_table;
SELECT c1, i2, add_months(c1,i2) FROM test_add_months_table;
SELECT c1, i4, add_months(c1,i4) FROM test_add_months_table;
SELECT c3, i2, add_months(c3,i2) FROM test_add_months_table;
SELECT c3, i4, add_months(c3,i4) FROM test_add_months_table;
drop table test_add_months_table;
rollback;
