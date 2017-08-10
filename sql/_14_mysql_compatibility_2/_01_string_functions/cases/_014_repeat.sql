create table tab3 (name char(10), adr char varying);
insert into tab3 values ( 'ion','aaabbbcccc1111222');
insert into tab3 values ( 'nicu','bbbccdd11112221111');
insert into tab3 values ( NULL,'bbbccdd11112221111');
insert into tab3 values ( 'nicu',NULL);


create table tab4 (name nchar(10), adr nchar varying);
insert into tab4 values ( n'ion',n'aabcc112');
insert into tab4 values ( n'nicu',n'bcd112211');
insert into tab4 values ( NULL,n'bbccd111211');
insert into tab4 values ( n'nicu',NULL);

create table tab5 (d1 date, d2 datetime, t timestamp, f float);
insert into tab5 values ( date'2009-11-12', datetime'2009-11-12 09:08:07', timestamp'2009-11-12 09:08:07', 12.34);
insert into tab5 values ( NULL, datetime'2009-11-12 09:08:07', timestamp'2009-11-12 09:08:07', NULL);
insert into tab5 values ( date'2009-11-12', NULL, timestamp'2009-11-12 09:08:07' , +152212.23123123);
insert into tab5 values ( date'2009-11-12', datetime'2009-11-12 09:08:07', NULL,-112.3213123);


create table src (name1 char varying, name2 char varying(20),name3 nchar varying, name4 nchar varying(20));
insert into src values ( 'google','google.com', NULL,n'google.com');
insert into src values ( 'google1','www.google1.com', n'google1',NULL);
insert into src values ( NULL ,'www.google2.com', n'google2',n'www.google2.com');
insert into src values ( 'google3',NULL,n'google3',n'www.google3.com');

select attr_name,data_type,prec from db_attribute where attr_name like '%name%' and class_name='src' order by 1;

create table dst1 as select repeat(name1,2) from src;

select attr_name,data_type,prec from db_attribute where attr_name like '%repeat%' and class_name='dst1';

create table dst2 as select repeat(name2,2) from src;

select attr_name,data_type,prec from db_attribute where attr_name like '%repeat%' and class_name='dst2';

create table dst3 as select repeat(name3,2) from src;

select attr_name,data_type,prec from db_attribute where attr_name like '%repeat%' and class_name='dst3';

create table dst4 as select repeat(name4,2) from src;

select attr_name,data_type,prec from db_attribute where attr_name like '%repeat%' and class_name='dst4';


select repeat('abc',2);

select repeat(123,'2');

select repeat(date'2001-10-20',2);

select repeat(datetime'2001-10-20 11:12:13',2);

select repeat(13123.1231,2);

select repeat(1e10,2);

select repeat('abc',0);

select repeat('abc',-1);

select repeat(n'abc',3);

select repeat('',2);

select repeat('',0);

select repeat(123,3);

select repeat(123,'a');

select repeat(b'1010101011',2);

select repeat(NULL,2);

select repeat(n'a',{2});


select name,adr,repeat(name,2) from tab3 order by 1,2,3;

select name,adr,repeat(adr,3) from tab3 order by 1,2,3;

select name,adr,repeat(name,0) from tab3 order by 1,2,3;

select name,adr,repeat(adr,0) from tab3 order by 1,2,3;



select name,adr,repeat(name,2) from tab4 order by 1,2,3;

select name,adr,repeat(adr,3) from tab4 order by 1,2,3;

select name,adr,repeat(name,0) from tab4 order by 1,2,3;

select name,adr,repeat(adr,0) from tab4 order by 1,2,3;



select d1,repeat(d1,2) from tab5 order by 1,2;

select d2,repeat(d2,3) from tab5 order by 1,2;

select f,repeat(f,2) from tab5 order by 1,2;

select t,repeat(t,2) from tab5 order by 1,2;

$varchar ,$abc,$int,$2
select repeat(?,?);

$varchar,$abc,$varchar,$2
select repeat(?,?);

$datetime,$2009-10-11 12:11:10,$varchar,$2
select repeat(?,?);

$date,$2009-10-11,$varchar,$2
select repeat(?,?);


$varchar ,$abc
select repeat(?,2);

$varchar,$abc
select repeat(?,2);

$datetime,$2009-10-11 12:11:10
select repeat(?,2);

$date,$2009-10-11
select repeat(?,2);


$int,$2
select repeat('abc',?);

$varchar,$2
select repeat('abc',?);



drop table tab3;
drop table tab4;
drop table tab5;

drop table src;
drop table dst1;
drop table dst2;
drop table dst3;
drop table dst4;

--1. Test string types
select if(repeat(cast('cubrid' as char(8)), 3) = 'cubrid  cubrid  cubrid  ', 'ok', 'nok');
select if(repeat(cast('cubrid' as varchar(8)), 3) = 'cubridcubridcubrid', 'ok', 'nok');
select if(repeat(cast(n'cubrid' as nchar(8)), 3) = n'cubrid  cubrid  cubrid  ', 'ok', 'nok');
select if(repeat(cast(n'cubrid' as nchar varying(8)), 3) = n'cubridcubridcubrid', 'ok', 'nok');

-- return an empty string
select if(repeat(cast('' as char(8)), 3) = '', 'ok', 'nok');
select if(repeat(cast('' as varchar(8)), 3) = '', 'ok', 'nok');
select if(repeat(cast(n'' as nchar(8)), 3) = n'', 'ok', 'nok');
select if(repeat(cast(n'' as nchar varying(8)), 3) = n'', 'ok', 'nok');

-- server side
create table t (c char(32), vc varchar(32), nc nchar(32), vnc nchar varying(32));
insert into t values('abcde', 'ABCDE', n'vwxyz', n'VWXYZ');
select if(repeat(c, 3) = repeat(cast('abcde' as char(32)), 3), 'ok', 'nok') from t;
select if(repeat(vc, 3) = repeat(cast('ABCDE' as varchar(32)), 3), 'ok', 'nok') from t;
select if(repeat(nc, 3) = repeat(cast(n'vwxyz' as nchar(32)), 3), 'ok', 'nok') from t;
select if(repeat(vnc, 3) = repeat(cast(n'VWXYZ' as nchar varying(32)), 3), 'ok', 'nok') from t;
drop table t;


--2. Test numeric types
select if(repeat(cast(12345 as short), 3) = repeat('12345', 3), 'ok', 'nok');
select if(repeat(cast(12345 as integer), 3) = repeat('12345', 3), 'ok', 'nok');
select if(repeat(cast(12345 as bigint), 3) = repeat('12345', 3), 'ok', 'nok');

select if(repeat(cast(12345.12 as float), 3) = repeat('12345.12', 3), 'ok', 'nok');
select if(repeat(cast(12345.123 as double), 3) = repeat('12345.123', 3), 'ok', 'nok');
select if(repeat(cast(12345.123 as monetary), 3) = repeat('$12345.12', 3), 'ok', 'nok');

select if(repeat(12345.12F, 3) = repeat('12345.12', 3), 'ok', 'nok');
select if(repeat(12345.123E0, 3) = repeat('12345.123', 3), 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary);
insert into t values(12345, 12345, 12345, 12345, 12345, 12345);
select if(repeat(s, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(i, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(bi, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(f, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(d, 3) = repeat('12345', 3), 'ok', 'nok') from t;
select if(repeat(m, 3) = repeat('$12345', 3), 'ok', 'nok') from t;
drop table t;

--3. Test date/time types
select if(repeat(date'2010-08-02', 3) = repeat('08/02/2010', 3), 'ok', 'nok');
select if(repeat(time'09:30:30 AM', 3) = repeat('09:30:30 AM', 3), 'ok', 'nok');
select if(repeat(datetime'09:30:30 AM 08/02/2010', 3) = repeat('09:30:30.000 AM 08/02/2010', 3), 'ok', 'nok');
select if(repeat(timestamp'09:30:30 AM 08/02/2010', 3) = repeat('09:30:30 AM 08/02/2010', 3), 'ok', 'nok');

-- server side
create table t (d date, t time, dt datetime, ts timestamp);
insert into t values(date'2010-07-30', time'09:30:30', datetime'2010-07-30 09:30:30', timestamp'2010-07-30 09:30:30');
select if(repeat(d, 3) = repeat('07/30/2010', 3), 'ok', 'nok') from t;
select if(repeat(t, 3) = repeat('09:30:30 AM', 3), 'ok', 'nok') from t;
select if(repeat(dt, 3) = repeat('09:30:30.000 AM 07/30/2010', 3), 'ok', 'nok') from t;
select if(repeat(ts, 3) = repeat('09:30:30 AM 07/30/2010', 3), 'ok', 'nok') from t;
drop table t;

--4. Test host variables
-- success
$varchar, $cubrid, $int, $3, $varchar, $cubridcubridcubrid
select if(repeat(?, ?) = ?, 'ok', 'nok');

$varchar, $a, $numeric, $1.5, $varchar, $aa
select if(repeat(?, ?) = ?, 'ok', 'nok');

$varchar, $a, $numeric, $1.4,$varchar, $a
select if(repeat(?, ?) = ?, 'ok', 'nok');

$varchar, $a, $float, $1.5f, $varchar, $aa
select if(repeat(?, ?) = ?, 'ok', 'nok');

$varchar, $a, $float, $1.4f, $varchar, $a
select if(repeat(?, ?) = ?, 'ok', 'nok');

$varchar, $a, $double, $1.5e0, $varchar, $aa
select if(repeat(?, ?) = ?, 'ok', 'nok');

$varchar, $a, $double, $1.4e0, $varchar, $a
select if(repeat(?, ?) = ?, 'ok', 'nok');


$int, $12345, $varchar, $12345
select if(repeat(?, 3) = repeat(?, 3), 'ok', 'nok');

$numeric[6,4], $12345.123, $varchar, $12345.123
select if(repeat(?, 3) = repeat(?, 3), 'ok', 'nok');

$float, $12345.123f, $float, $12345.123
select if(repeat(?, 3) = repeat(cast(? AS VARCHAR), 3), 'ok', 'nok');

$double, $12345.123e0, $double, $12345.123
select if(repeat(?, 3) = repeat(cast (? AS VARCHAR), 3), 'ok', 'nok');

$monetary, $12345.123, $monetary, $12345.123
select if(repeat(?, 3) = repeat(cast (? AS VARCHAR), 3), 'ok', 'nok');

$date, $2010-08-02, $varchar, $08/02/2010
select if(repeat(?, 3) = repeat(?, 3), 'ok', 'nok');

$time, $09:30:30, $varchar, $09:30:30 AM
select if(repeat(?, 3) = repeat(?, 3), 'ok', 'nok');

$datetime, $09:30:30 AM 08/02/2010, $varchar, $09:30:30 AM 08/02/2010
select if(repeat(?, 3) = repeat(?, 3), 'ok', 'nok');

$timestamp, $2010-08-02 09:30:30, $varchar, $09:30:30.000 AM 08/02/2010
select if(repeat(?, 3) = repeat(?, 3), 'ok', 'nok');

-- failure
$varchar, $a, $date, $2010-09-02
select repeat(?, ?);

$varchar, $a, $datetime, $2010-09-02 17:30:30
select repeat(?, ?);

$varchar, $a, $timestamp, $2010-09-02 17:30:30
select repeat(?, ?);

$varchar, $a, $time, $17:30:30
select repeat(?, ?);

$varchar, $a, $binary, $0b00110001
select repeat(?, ?);

-- cannot coerce nchar to varchar
$varnchar, $a, $int, $2
select repeat(?, ?);

--Test the range of count
-- return NULL
select if(repeat(null, 3) is null, 'ok', 'nok');
select if(repeat('cubrid', null) is null, 'ok', 'nok');

select if(repeat('cubrid', 0) = '', 'ok', 'nok');
select if(repeat('cubrid', -1) = '', 'ok', 'nok');

-- rounding (TBD)
select if(repeat('cubrid', 1.5) = repeat('cubrid', 2), 'ok', 'nok');
select if(repeat('cubrid', 1.4) = repeat('cubrid', 1), 'ok', 'nok');
select if(repeat('cubrid', 0.4) = repeat('cubrid', 0), 'ok', 'nok');


--Test the range of return string
-- TBD
select if(char_length(repeat('x', cast(1073741823 as int))) = 1073741823, 'ok', 'nok');

--Test unsupported types
-- error
select repeat(cast(B'1' as bit(8)), 2);
select repeat(cast(B'1' as bit varying(8)), 2);