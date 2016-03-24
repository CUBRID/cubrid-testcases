-- insert(string, position, length, substring);
create table tab3 (name char(10), adr char varying,i integer);
insert into tab3 values ( 'google','www.google.com',-1);
insert into tab3 values ( 'google1','www......google1.....com',1);
insert into tab3 values ( NULL ,'www......google1.....com',-1);
insert into tab3 values ( 'google1',NULL,2);

create table tab4 (name nchar(10), adr nchar varying);
insert into tab4 values ( n'google',n'www.google.com');
insert into tab4 values ( n'google1',n'www......google1.....com');
insert into tab4 values ( NULL ,n'www......google1.....com');
insert into tab4 values ( n'google1',NULL);

create table tab6 (d1 date, d2 datetime, t timestamp, f float);
insert into tab6 values ( date'2009-11-12', datetime'2009-11-12 09:08:07', timestamp'2009-11-12 09:08:07', 12.34);
insert into tab6 values ( NULL, datetime'2009-11-12 09:08:07', timestamp'2009-11-12 09:08:07', NULL);
insert into tab6 values ( date'2009-11-12', NULL, timestamp'2009-11-12 09:08:07' , +152212.23123123);
insert into tab6 values ( date'2009-11-12', datetime'2009-11-12 09:08:07', NULL,-112.3213123);

create table src (name1 char varying, name2 char varying(20),name3 nchar varying, name4 nchar varying(20));
insert into src values ( 'google','google.com', NULL,n'google.com');
insert into src values ( 'google1','www.google1.com', n'google1',NULL);
insert into src values ( NULL ,'www.google2.com', n'google2',n'www.google2.com');
insert into src values ( 'google3',NULL,n'google3',n'www.google3.com');

select attr_name,data_type,prec from db_attribute where attr_name like '%name%' and class_name='src' order by 1;

create table dst1 as select insert(name1,1,2,'xx') from src;

select data_type,prec from db_attribute where attr_name like '%insert%' and class_name='dst1';

create table dst2 as select insert(name2,1,2,'xx') from src;

select data_type,prec from db_attribute where attr_name like '%insert%' and class_name='dst2';

create table dst3 as select insert(name3,1,2,n'xx') from src;

select data_type,prec from db_attribute where attr_name like '%insert%' and class_name='dst3';

create table dst4 as select insert(name4,1,2,n'xx') from src;

select data_type,prec from db_attribute where attr_name like '%insert%' and class_name='dst4';

select insert('123456',1,1,'x');

select insert('123456',2,1,'x');

select insert('123456',2,5,'x');

select insert('1',2,1,'x');

select insert('12',3,1,'x');

select insert('12',3,0,'x');

select insert('12',3,-1,'x');

select insert('12',4,-1,'x');

select insert('1',1,1,'x');

select insert('',1,1,'x');

select insert(n'123456',1,1,n'x');

select insert('123456',1,3,'x');

select insert('123456',1,1,'xx');

select insert('123456',1,6,'xx');

select insert('123456',1,7,'xx');

select insert('123456',0,7,'xx');

select insert('123456',-1,7,'xx');

select insert('123456',1,0,'xx');

select insert('123456',1,-1,'xx');


select date'2010-11-12',insert(date'2010-11-12',1,2,'xx');

select datetime'2010-11-12 11:12:13',insert(datetime'2010-11-12 11:12:13',1,2,'xx');

select time'11:12:13',insert(time'11:12:13',1,2,'xx');

select timestamp'2010-11-12 11:12:13',insert(timestamp'2010-11-12 11:12:13',1,2,'xx');

select 12.34,insert(12.34,3,1,'x');

select 1e10,insert(1e10,2,1,'x');

select insert('123456','2','1','xx');

select insert('abcdef','2','1','22');

select insert('',1,1,'x');

select insert('',1,1,'');

select insert('',0,0,'');

select insert(NULL,1,-1,'xx');

select insert('123456',NULL,-1,'xx');

select insert('123456',1,NULL,'xx');

select insert('123456',1,-1,NULL);

select insert(b'010111011010',1,1,b'1101');

-- should fail
select insert('123456',1,{1},1);

-- should fail
select insert({'123456'},1,1,1);

-- should fail
select insert('123456',1,1,{1});

select insert(200,1,1,n'1');


select name,adr,insert(name,2,2,'xx') from tab3 order by name,adr;

select name,adr,insert(adr,2,2,'xx') from tab3 order by name,adr;

select name,adr,insert(name,2,2,adr) from tab3 order by name,adr;

select name,adr,insert(adr,2,2,name) from tab3 order by name,adr;



select name,adr,insert(name,2,2,n'xx') from tab4 order by name,adr;

select name,adr,insert(adr,2,2,n'xx') from tab4 order by name,adr;

select name,adr,insert(name,2,2,adr) from tab4 order by name,adr;

select name,adr,insert(adr,2,2,name) from tab4 order by name,adr;



select d1,insert(d1,1,2,'') from tab6 order by f;

select d2,insert(d2,1,2,'') from tab6 order by f;

select f,insert(f,2,2,0) from tab6 order by f;

select t,insert(t,2,2,0) from tab6 order by f;


select insert('abcdef',date'10/10/2010',1,'22');

select insert(n'123456',2,2,'xx');

select insert('123456',2,2,n'xx');

select insert(b'010111011010',1,1,'1101');

select insert('010111011010',1,1,b'1101');


$varchar,$123456,$varchar,$1,$int,$2,$char,$xx
select insert(?,?,?,?);

$varchar,$123456,$int,$0
select insert(?,1,2,?);

$varchar,$1,$int,$2
select insert(123456,?,?,'xx');

$datetime,$20091112 12:11:22,$varchar,$0000
select insert(?,1,4,?);

create table tab1 (name char varying, i integer ) partition by LIST ( INSERT(name,1,1,'x'))
	( PARTITION p0 VALUES IN ('x0','x00') ,
	  PARTITION p1 VALUES IN ('x1','x11') );

insert into tab1 values ('11',1), ('00',2), ('111',6), ('000',11), ('011',8);

select * from tab1__p__p0 order by i;
select * from tab1__p__p1 order by i;


create table tab1a (name char varying, i integer ) partition by LIST ( INSERT(name,i,1,'x'))
	( PARTITION p0 VALUES IN ('x0','x00') ,
	  PARTITION p1 VALUES IN ('x1','x11') );

-- this test should be succesfull 	  
create table tab1b (name char varying, i integer ) partition by LIST ( INSERT('1',i,i,'x'))
	( PARTITION p0 VALUES IN ('x0','x00') ,
	  PARTITION p1 VALUES IN ('x1','x11') );
	  
create table tab1c (name char varying, i integer ) partition by LIST ( INSERT('abc',i+1,1,'x'))
	( PARTITION p0 VALUES IN ('x0','x00') ,
	  PARTITION p1 VALUES IN ('x1','x11') );

-- should fail
create table t1 (s varchar(10) default insert(b'1',2,3,'a'));
-- should fail
drop table t1;
 
select tab3.adr,src.name2 from tab3 join src on insert(tab3.adr,1,4,'')=src.name2;  	  

-- as DEFAULT value:
create table ttt_insert (s varchar(22) default insert ('abcd',1,3,'123'));
insert into ttt_insert default values;
select * from ttt_insert order by 1;
drop table ttt_insert;

drop table tab1;
drop table tab1a;
drop table tab1b;
drop table tab1c;
drop table tab3;
drop table tab4;
drop table tab6;
drop table src;
drop table dst1;
drop table dst2;
drop table dst3;
drop table dst4;

--Test string types
select if(insert(cast('abcdefghijk' as varchar(32)), 5, 3, 'XXX') = 'abcdXXXhijk', 'ok', 'nok');
select if(insert(cast('abcdefghijk' as char(32)), 5, 3, 'XXX') = 'abcdXXXhijk', 'ok', 'nok');
select if(insert(cast(n'abcdefghijk' as nchar varying(32)), 5, 3, n'XXX') = n'abcdXXXhijk', 'ok', 'nok');
select if(insert(cast(n'abcdefghijk' as nchar(32)), 5, 3, n'XXX') = n'abcdXXXhijk', 'ok', 'nok');

-- server side
create table t (c char(32), vc varchar(32), nc nchar(32), vnc nchar varying(32));
insert into t values('abcde', 'ABCDE', n'vwxyz', n'VWXYZ');
select if(insert(c, 2, 3, c) = insert(cast('abcde' as char(32)), 2, 3, cast('abcde' as char(32))), 'ok', 'nok') from t;
select if(insert(vc, 2, 3, vc) = insert(cast('ABCDE' as varchar(32)), 2, 3, cast('ABCDE' as varchar(32))), 'ok', 'nok') from t;
select if(insert(nc, 2, 3, nc) = insert(cast(n'vwxyz' as nchar(32)), 2, 3, cast(n'vwxyz' as nchar(32))), 'ok', 'nok') from t;
select if(insert(vnc, 2, 3, vnc) = insert(cast(n'VWXYZ' as nchar varying(32)), 2, 3, cast(n'VWXYZ' as nchar varying(32))), 'ok', 'nok') from t;
drop table t;

-- error
select insert(cast(n'abcdefghijk' as nchar varying(32)), 5, 3, 'XXX');
select insert(cast(n'abcdefghijk' as nchar(32)), 5, 3, 'XXX');
select insert(cast('abcdefghijk' as char varying(32)), 5, 3, n'XXX');
select insert(cast('abcdefghijk' as char(32)), 5, 3, n'XXX');


-- Test numeric types
select if(insert(cast(12345 as short), 3, 2, cast(99 as short)) = '12995', 'ok', 'nok');
select if(insert(cast(12345 as integer), 3, 2, cast(99 as integer)) = '12995', 'ok', 'nok');
select if(insert(cast(12345 as bigint), 3, 2, cast(99 as bigint)) = '12995', 'ok', 'nok');

--following tests will fail because of the way that the cast operator works from float/double to varchar
select if(insert(cast(12345.12 as float), 3, 2, cast(9.9 as float)) = '129.95.12', 'ok', 'nok');
select if(insert(cast(12345.123 as double), 3, 2, cast(9.9 as double)) = '129.95.123', 'ok', 'nok');
select if(insert(12345.12F, 3, 2, 9.9F) = '129.95.12', 'ok', 'nok');
select if(insert(12345.123E0, 3, 2, 9.9E0) = '129.95.123', 'ok', 'nok');

select if(insert(cast(12345.12345 as monetary), 3, 2, cast(9.9 as monetary)) = '$1$9.945.12', 'ok', 'nok');
select if(insert($12345.12345, 3, 2, $9.9) = '$1$9.945.12', 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary);
insert into t values(12345, 12345, 12345, 12345, 12345, 12345);
select if(insert(s, 2, 3, s) = insert(cast(12345 as short), 2, 3, cast(12345 as short)), 'ok', 'nok') from t;
select if(insert(i, 2, 3, i) = insert(cast(12345 as int), 2, 3, cast(12345 as int)), 'ok', 'nok') from t;
select if(insert(bi, 2, 3, bi) = insert(cast(12345 as bigint), 2, 3, cast(12345 as bigint)), 'ok', 'nok') from t;
select if(insert(f, 2, 3, f) = insert(cast(12345 as float), 2, 3, cast(12345 as float)), 'ok', 'nok') from t;
select if(insert(d, 2, 3, d) = insert(cast(12345 as double), 2, 3, cast(12345 as double)), 'ok', 'nok') from t;
select if(insert(m, 2, 3, m) = insert(cast(12345 as monetary), 2, 3, cast(12345 as monetary)), 'ok', 'nok') from t;
drop table t;


--Test date/time types
select if(insert(date'2010-07-30', 4, 2, date'2010-08-01') = '07/08/01/2010/2010', 'ok', 'nok');
select if(insert(time'09:30:30', 4, 2, time'15:40:40') = '09:03:40:40 PM:30 AM', 'ok', 'nok');
select if(insert(datetime'2010-07-30 09:30:30', 4, 2, datetime'2010-08-01 15:40:40') = '09:03:40:40.000 PM 08/01/2010:30.000 AM 07/30/2010', 'ok', 'nok');
select if(insert(timestamp'2010-07-30 09:30:30', 4, 2, timestamp'2010-08-01 15:40:40') = '09:03:40:40 PM 08/01/2010:30 AM 07/30/2010', 'ok', 'nok');

-- server side
create table t (d date, t time, dt datetime, ts timestamp);
insert into t values(date'2010-07-30', time'09:30:30', datetime'2010-07-30 09:30:30', timestamp'2010-07-30 09:30:30');
select if(insert(d, 4, 2, d) = insert(date'2010-07-30', 4, 2, date'2010-07-30'), 'ok', 'nok') from t;
select if(insert(t, 4, 2, t) = insert(time'09:30:30', 4, 2, time'09:30:30'), 'ok', 'nok') from t;
select if(insert(dt, 4, 2, dt) = insert(datetime'2010-07-30 09:30:30', 4, 2, datetime'2010-07-30 09:30:30'), 'ok', 'nok') from t;
select if(insert(ts, 4, 2, ts) = insert(timestamp'2010-07-30 09:30:30', 4, 2, timestamp'2010-07-30 09:30:30'), 'ok', 'nok') from t;
drop table t;

-- Test bit types
-- TBD

--Test the range of pos and len
-- out of range of pos
select if(insert('abcde', 0, 3, 'X') = insert('abcde', 7, 3, 'X'), 'ok', 'nok');

select if(insert('abcde', 6, 3, 'xxxxx') = 'abcdexxxxx', 'ok', 'nok');

-- a negative value of len
select if(insert('abcde', 2, -1, 'x') = insert('abcde', 2, 4, 'x'), 'ok', 'nok'); 

-- floating-point number
select if(insert('abcde', 1.5, 3, 'xxxxx') = insert('abcde', 2.4, 3, 'xxxxx'), 'ok', 'nok');
select if(insert('abcde', 2, 2.5, 'xxxxx') = insert('abcde', 2, 3.4, 'xxxxx'), 'ok', 'nok');
select if(insert('abcde', 2, -0.5, 'x') = insert('abcde', 2, -1, 'x'), 'ok', 'nok'); 
select if(insert('abcde', 2, -0.4, 'x') = insert('abcde', 2, 0, 'x'), 'ok', 'nok'); 

-- other types - TBD
select insert('abcde', '1', 3, 'x');
select insert('abcde', n'1', 3, 'x');
select insert('abcde', $1, 3, 'x');

-- wrong types
select insert('abcde', current_date, 3, 'x');
select insert('abcde', current_time, 3, 'x');
select insert('abcde', current_datetime, 3, 'x');
select insert('abcde', current_timestamp, 3, 'x');
select insert('abcde', cast(B'1' as bit(1)), 3, 'x');
select insert('abcde', cast(B'1' as bit varying(1)), 3, 'x');

select insert('abcde', 1, current_date, 'x');
select insert('abcde', 1, current_time, 'x');
select insert('abcde', 1, current_datetime, 'x');
select insert('abcde', 1, current_timestamp, 'x');
select insert('abcde', 1, cast(B'1' as bit(1)), 'x');
select insert('abcde', 1, cast(B'1' as bit varying(1)), 'x');

-- NULL is given
select if(insert(null, 1, 3, 'x') is null, 'ok', 'nok');
select if(insert('abcde', null, 3, 'x') is null, 'ok', 'nok');
select if(insert('abcde', 1, null, 'x') is null, 'ok', 'nok');
select if(insert('abcde', 1, 3, null) is null, 'ok', 'nok');

-- Test host variables
-- success
-- tests using float and double will fail because of the precision used in casts from float/double to string
$varchar, $abcdefghijk, $int, $5, $int, $3, $varchar, $XXX, $varchar, $abcdXXXhijk
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$int, $12345, $int, $3, $int, $2, $int, $99, $varchar, $12995
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$numeric[6,4], $12345.123, $int, $3, $int, $2, $numeric[6,4], $9.9, $varchar, $129.95.123
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$date, $2010-07-30, $int, $4, $int, $2, $date, $2010-08-01, $varchar, $07/08/01/2010/2010
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$time ,$09:30:30, $int, $4, $int, $2, $time, $15:40:40, $varchar, $09:03:40:40 PM:30 AM
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$datetime, $2010-07-30 09:30:30, $int, $4, $int, $2, $datetime, $2010-08-01 15:40:40, $varchar, $2012010-08-01 15:40:4007-30 09:30:30
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$timestamp, $2010-07-30 09:30:30, $int, $4, $int, $2, $timestamp, $2010-08-01 15:40:40, $varchar, $09:03:40:40.000 PM 08/01/2010:30.000 AM 07/30/2010
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$varchar, $abcde, $int, $6, $int, $3, $varchar, $xxxxx, $varchar, $abcdexxxxx
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$binary, $0b0001001000110100, $int, $1, $int, $2, $varchar, $x, $varchar, $x0001001000110100
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$binary, $0b0001001000110100, $int, $1, $int, $2, $binary, $0b10001000, $varchar, $0b100010000001001000110100
select if(insert(?, ?, ?, ?) = ?, 'ok', 'nok');

$int, $0, $int, $3, $varchar, $X, $int, $7, $int, $3, $varchar, $X
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $int, $-1, $varchar, $x, $int, $2, $int, $4, $varchar, $x
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$numeric[6,3], $1.5, $int, $3, $varchar, $xxxxx, $numeric[6,3], $2.4, $int, $3, $varchar, $xxxxx
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $numeric[6,3], $2.5, $varchar, $xxxxx, $int, $2, $numeric[6,3], $3.4, $varchar, $xxxxx
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $numeric[6,3], $-0.5, $varchar, $x, $int, $2, $int, $-1, $varchar, $x
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $numeric[6,3], $-0.4, $varchar, $x, $int, $2, $int, $0, $varchar, $x
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$float, $1.5, $int, $3, $varchar, $xxxxx, $float, $2.4, $int, $3, $varchar, $xxxxx
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $float, $2.5f, $varchar, $xxxxx, $int, $2, $float, $3.4f, $varchar, $xxxxx
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $double, $-0.5e0, $varchar, $x, $int, $2, $int, $-1, $varchar, $x
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

$int, $2, $double, $-0.4e0, $varchar, $x, $int, $2, $int, $0, $varchar, $x
select if(insert('abcde', ?, ?, ?) = insert('abcde', ?, ?, ?), 'ok', 'nok');

-- failure
$varchar, $abcde, $varchar, $a, $int, $2, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $varchar, $a, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $varnchar, $a, $int, $2, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $varnchar, $a, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $date, $2010-09-02, $int, $1, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $date, $2010-09-02, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $datetime, $2010-09-02 16:30:30, $int, $1, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $datetime, $2010-09-02 16:30:30, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $timestamp, $2010-09-02 16:30:30, $int, $1, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $timestamp, $2010-09-02 16:30:30, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $time, $16:30:30, $int, $1, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $time, $16:30:30, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $int, $1, $binary, $0b0001, $varchar, $x
select insert(?, ?, ?, ?);

$varchar, $abcde, $binary, $0b0001, $int, $1, $varchar, $x
select insert(?, ?, ?, ?);

