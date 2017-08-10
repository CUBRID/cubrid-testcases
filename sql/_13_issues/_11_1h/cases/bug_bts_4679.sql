create table datetime_tbl (t_datetime datetime);
create table date_tbl (t_date date);
create table time_tbl (t_time time);
create table timestamp_tbl (t_timestamp timestamp);
create table double_tbl (t_double double);
create table float_tbl (t_float float);
create table numeric_tbl (t_numeric numeric);
create table bigint_tbl (t_bigint bigint);
create table int_tbl (t_int int);
create table short_tbl (t_short short);
create table monetary_tbl (t_monetary monetary);
create table bit_tbl (t_bit bit(8192));
create table varbit_tbl (t_varbit bit varying(8192));
create table char_tbl (t_char char(1024));
create table varchar_tbl (t_varchar varchar(1024));
create table nchar_tbl (t_nchar nchar(1024));
create table nvarchar_tbl (t_nvarchar nchar varying(1024));

delete from char_tbl;
insert into char_tbl values ('2011-02-27 06:21:37.123 pm');
insert into datetime_tbl select * from char_tbl;
select * from datetime_tbl;

delete from char_tbl;
insert into char_tbl values ('2011-02-27');
insert into date_tbl select * from char_tbl;
select * from date_tbl;

delete from char_tbl;
insert into char_tbl values ('06:21:37 pm');
insert into time_tbl select * from char_tbl;
select * from time_tbl;

delete from char_tbl;
insert into char_tbl values ('05:12:13 PM 02/10/2011');
insert into timestamp_tbl select * from char_tbl;
select * from timestamp_tbl;

delete from char_tbl;
insert into char_tbl values ('123456789012345.9821');
insert into double_tbl select * from char_tbl;
select * from double_tbl;

delete from char_tbl;
insert into char_tbl values ('1234567890.987654');
insert into float_tbl select * from char_tbl;
select * from float_tbl;

delete from char_tbl;
insert into char_tbl values ('123456789012345');
insert into numeric_tbl select * from char_tbl;
select * from numeric_tbl;

delete from char_tbl;
insert into char_tbl values ('922337203684775806');
insert into bigint_tbl select * from char_tbl;
select * from bigint_tbl;

delete from char_tbl;
insert into char_tbl values ('1122334455');
insert into int_tbl select * from char_tbl;
select * from int_tbl;

delete from char_tbl;
insert into char_tbl values ('11223');
insert into short_tbl select * from char_tbl;
select * from short_tbl;

delete from char_tbl;
insert into char_tbl values ('123456789abcdef');
insert into bit_tbl select * from char_tbl;
select * from bit_tbl;
insert into varbit_tbl select * from char_tbl;
select * from varbit_tbl;

delete from char_tbl;
insert into char_tbl values ('hello CUBRID');
insert into varchar_tbl select * from char_tbl;
select * from varchar_tbl;

insert into nchar_tbl select * from char_tbl;
select * from nchar_tbl;
insert into nvarchar_tbl select * from char_tbl;
select * from nvarchar_tbl;



drop datetime_tbl;
drop date_tbl;
drop time_tbl;
drop timestamp_tbl;
drop double_tbl;
drop float_tbl;
drop numeric_tbl;
drop bigint_tbl;
drop int_tbl;
drop short_tbl;
drop char_tbl;
drop varchar_tbl;
drop monetary_tbl;
drop bit_tbl;
drop varbit_tbl;
drop nchar_tbl;
drop nvarchar_tbl;

