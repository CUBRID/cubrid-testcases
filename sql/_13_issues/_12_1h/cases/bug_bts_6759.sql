--TEST: No error returns when setting an invalid default value to a timestamp column using 'ALTER COLUMN ... SET DEFAULT' statement

create table t_numeric (s short, i integer, b bigint, n numeric, f float, d double, m monetary);
create table t_datetime (d date, t time, ts timestamp, dt datetime);
create table t_bits (b bit(20), bv bit varying);
create table t_chars (c char(10), vc varchar);


--test alter table ... alter column ... set default ... on numeric data types
alter table t_numeric alter column s set default 'aaa';
alter table t_numeric alter column s set default '2012-12-10';
alter table t_numeric alter column s set default '15';
alter table t_numeric alter column s set default 15;
alter table t_numeric alter column s set default 40000;

alter table t_numeric alter column i set default 'aaa';
alter table t_numeric alter column i set default '2012-12-10';
alter table t_numeric alter column i set default '15';
alter table t_numeric alter column i set default 15;
alter table t_numeric alter column i set default 2200000000;

alter table t_numeric alter column b set default 'aaa';
alter table t_numeric alter column b set default '2012-12-10';
alter table t_numeric alter column b set default '15';
alter table t_numeric alter column b set default 15;
alter table t_numeric alter column b set default 10000000000000000000;

alter table t_numeric alter column n set default 'aaa';
alter table t_numeric alter column n set default '2012-12-10';
alter table t_numeric alter column n set default '15';
alter table t_numeric alter column n set default 15;
alter table t_numeric alter column n set default 15.132;
alter table t_numeric alter column n set default 9999999999999999999.99;

alter table t_numeric alter column f set default 'aaa';
alter table t_numeric alter column f set default '2012-12-10';
alter table t_numeric alter column f set default '15';
alter table t_numeric alter column f set default 15;
alter table t_numeric alter column f set default 15.132;
alter table t_numeric alter column f set default 12e+12;
alter table t_numeric alter column f set default 4e+39;

alter table t_numeric alter column d set default 'aaa';
alter table t_numeric alter column d set default '2012-12-10';
alter table t_numeric alter column d set default '15';
alter table t_numeric alter column d set default 15;
alter table t_numeric alter column d set default 15.132;
alter table t_numeric alter column d set default 12e+12;
--######### CUBRID BUG CUBRIDSUS-7720 ##########
--alter table t_numeric alter column d set default 2e+309;

alter table t_numeric alter column m set default 'aaa';
alter table t_numeric alter column m set default '2012-12-10';
alter table t_numeric alter column m set default '15';
alter table t_numeric alter column m set default 15;
alter table t_numeric alter column m set default 15.132;
alter table t_numeric alter column m set default 12e+12;
alter table t_numeric alter column m set default 4e+39;
--######### CUBRID BUG CUBRIDSUS-7720 ########## 
--alter table t_numeric alter column m set default 2e+309;

show columns in t_numeric;


--test alter table ... alter column ... set default ... on datetime data types
alter table t_datetime alter column d set default 'aaa';
alter table t_datetime alter column d set default '2012-12-10';
alter table t_datetime alter column d set default '12/10/2012';
desc t_datetime;
alter table t_datetime alter column d set default '00:00:00';
alter table t_datetime alter column d set default '01:15:45 PM 2008-10-31';
alter table t_datetime alter column d set default '15';
alter table t_datetime alter column d set default 15;

alter table t_datetime alter column t set default 'aaa';
alter table t_datetime alter column t set default '2012-12-10';
alter table t_datetime alter column t set default '12/10/2012';
alter table t_datetime alter column t set default '00:00:00';
desc t_datetime;
alter table t_datetime alter column t set default '01:15:45 PM 2008-10-31';
desc t_datetime;
alter table t_datetime alter column t set default '15';
alter table t_datetime alter column t set default 15;

alter table t_datetime alter column ts set default 'aaa';
alter table t_datetime alter column ts set default '2012-12-10';
alter table t_datetime alter column ts set default '12/10/2012';
desc t_datetime;
alter table t_datetime alter column ts set default '00:00:00';
alter table t_datetime alter column ts set default '01:15:45 PM 2008-10-31';
desc t_datetime;
alter table t_datetime alter column ts set default '15';
alter table t_datetime alter column ts set default 15;

alter table t_datetime alter column dt set default 'aaa';
alter table t_datetime alter column dt set default '2012-12-10';
alter table t_datetime alter column dt set default '12/10/2012';
alter table t_datetime alter column dt set default '00:00:00';
alter table t_datetime alter column dt set default '01:15:45 PM 2008-10-31';
alter table t_datetime alter column dt set default '15';
alter table t_datetime alter column dt set default 15;
desc t_datetime;



--test alter table ... alter column ... set default ... on bit data types
alter table t_bits alter column b set default B'1';
alter table t_bits alter column b set default 0b1;
desc t_bits;
alter table t_bits alter column b set default B'1010';
alter table t_bits alter column b set default 0xAA;
alter table t_bits alter column b set default X'aaa';
alter table t_bits alter column b set default '2012-12-10';
alter table t_bits alter column b set default 15;

alter table t_bits alter column bv set default B'1';
alter table t_bits alter column bv set default 0b1;
alter table t_bits alter column bv set default B'1010';
desc t_bits;
alter table t_bits alter column bv set default 0xAA;
desc t_bits;
alter table t_bits alter column bv set default X'aaa';
alter table t_bits alter column bv set default '2012-12-10';
alter table t_bits alter column bv set default 15;



--test alter table ... alter column ... set default ... on char data types
alter table t_chars alter column c set default 'aaa';
desc t_chars;
alter table t_chars alter column c set default 'a';
alter table t_chars alter column c set default '2012-12-10';
alter table t_chars alter column c set default '15';
alter table t_chars alter column c set default 15;

alter table t_chars alter column vc set default 'aaa';
alter table t_chars alter column vc set default 'a';
alter table t_chars alter column vc set default '2012-12-10';
desc t_chars;
alter table t_chars alter column vc set default '15';
desc t_chars;
alter table t_chars alter column vc set default 15;


drop table t_numeric, t_datetime, t_bits, t_chars;
