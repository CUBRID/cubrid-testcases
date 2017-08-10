--create tables
create table int_table(a int, dummy int);
insert into int_table values(1, 1);
insert into int_table(dummy) values(2);

create table short_table(a short, dummy int);
insert into short_table values(1, 1);
insert into short_table(dummy) values(2);

create table bigint_table(a bigint, dummy int);
insert into bigint_table values(1, 1);
insert into bigint_table(dummy) values(2);

create table numeric_table (a numeric, dummy int);
insert into numeric_table values(1, 1);
insert into numeric_table(dummy) values(2);

create table float_table(a float, dummy int);
insert into float_table values(1, 1);
insert into float_table(dummy) values(2);

create table double_table(a double, dummy int);
insert into double_table values(1, 1);
insert into double_table(dummy) values(2);

create table date_table(a date, dummy int);
insert into date_table values(DATE '2011-11-11', 1);
insert into date_table(dummy) values(2);

create table time_table(a time, dummy int);
insert into time_table values(TIME '00:00:00', 1);
insert into time_table(dummy) values(2);

create table timestamp_table(a timestamp, dummy int);
insert into timestamp_table values(TIMESTAMP '11/11', 1);
insert into timestamp_table(dummy) values(2);

create table datetime_table(a datetime, dummy int);
insert into datetime_table values(DATETIME '11/11', 1);
insert into datetime_table(dummy) values(2);

create table bit_table(a bit(10), dummy int);
insert into bit_table values(B'1', 1);
insert into bit_table(dummy) values(2);

create table varbit_table(a bit varying(10), dummy int);
insert into varbit_table values(B'1', 1);
insert into varbit_table(dummy) values(2);

create table char_table(a char(10), dummy int);
insert into char_table values('1', 1);
insert into char_table(dummy) values(2);

create table varchar_table(a char(10), dummy int);
insert into varchar_table values('1', 1);
insert into varchar_table(dummy) values(2);

create table clob_table(a clob, dummy int);
insert into clob_table values('1', 1);
insert into clob_table(dummy) values(2);

create table set_table(a set of int, dummy int);
insert into set_table values({1}, 1);
insert into set_table(dummy) values(2);

-- ifnull for char
select TA.a, ifnull(TA.a, TB.a) from char_table TA, int_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, short_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, bigint_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, numeric_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, float_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, double_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, date_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, time_table TB where TB.a is not null;
select TA.a, substring(ifnull(TA.a, TB.a),1,18) from char_table TA, timestamp_table TB where TB.a is not null;
select TA.a, substring(ifnull(TA.a, TB.a),1,22) from char_table TA, datetime_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, bit_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, varbit_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, char_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, varchar_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, clob_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from char_table TA, set_table TB where TB.a is not null;

-- varbit
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, int_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, short_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, bigint_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, numeric_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, float_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, double_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, date_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, time_table TB where TB.a is not null;
select TA.a, substring(ifnull(TA.a, TB.a),1,18) from varbit_table TA, timestamp_table TB where TB.a is not null;
select TA.a, substring(ifnull(TA.a, TB.a),1,22) from varbit_table TA, datetime_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, bit_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, varbit_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, char_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, varchar_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, clob_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varbit_table TA, set_table TB where TB.a is not null;

-- varchar
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, int_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, short_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, bigint_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, numeric_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, float_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, double_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, date_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, time_table TB where TB.a is not null;
select TA.a, substring(ifnull(TA.a, TB.a),1,18) from varchar_table TA, timestamp_table TB where TB.a is not null;
select TA.a, substring(ifnull(TA.a, TB.a),1,22) from varchar_table TA, datetime_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, bit_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, varbit_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, char_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, varchar_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, clob_table TB where TB.a is not null;
select TA.a, ifnull(TA.a, TB.a) from varchar_table TA, set_table TB where TB.a is not null;

-- set
select TA.a, ifnull(TA.a, TB.a) from set_table TA, set_table TB where TB.a is not null;

--drop tables
drop table double_table;
drop table date_table;
drop table time_table;
drop table timestamp_table;
drop table datetime_table;
drop table bit_table;
drop table varbit_table;
drop table char_table;
drop table varchar_table;
drop table clob_table;
drop table set_table;
drop table int_table;
drop table short_table;
drop table bigint_table;
drop table numeric_table;
drop table float_table;
