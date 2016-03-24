autocommit off;
create table test_months_between_table(
    d1 date,
    d2 date,
    d3 date 
);
insert into test_months_between_table (d1,d2) values(date '9/6/1976',date '2/6/1976');
SELECT d1, date '2/6/1976', months_between(d1,date '2/6/1976') FROM test_months_between_table;
SELECT date '9/6/1976',d2, months_between(date '9/6/1976',d2) FROM test_months_between_table;
SELECT d1,d2, months_between(d1,d2) FROM test_months_between_table;
SELECT d1, d3, months_between(d1,d3) FROM test_months_between_table;
SELECT d3, d2, months_between(d3,d2) FROM test_months_between_table;
SELECT d3, d3, months_between(d3,d3) FROM test_months_between_table;
drop table test_months_between_table;
rollback;
