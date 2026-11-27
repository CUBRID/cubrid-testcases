create table tab3 (name char(10), adr char varying);
insert into tab3 values ( 'google','www.google.com');
insert into tab3 values ( 'google1','www......google1.....com');
insert into tab3 values ( NULL ,'www......google1.....com');
insert into tab3 values ( 'google1',NULL);

create table tab4 (name nchar(10), adr nchar varying);
insert into tab4 values ( n'google',n'www.google.com');
insert into tab4 values ( n'google1',n'www......google1.....com');
insert into tab4 values ( NULL ,n'www......google1.....com');
insert into tab4 values ( n'google1',NULL);

create table tab5 (name nchar varying, adr nchar varying);
insert into tab5 values ( n'google',n'www.google.com');
insert into tab5 values ( n'google1',n'www......google1.....com');
insert into tab5 values ( NULL ,n'www......google1.....com');
insert into tab5 values ( n'google1',NULL);

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

select attr_name,data_type,prec from db_attribute where attr_name like '%name%' and class_name='src' order by attr_name,data_type,prec;

create table dst1 as select substring_index(name1,'g',2) as [substring_index(name1,'g',2)] from src;

select data_type,prec from db_attribute where attr_name like '%substring_index%' and class_name='dst1';

create table dst2 as select substring_index(name2,'g',2) as [substring_index(name2,'g',2)] from src;

select data_type,prec from db_attribute where attr_name like '%substring_index%' and class_name='dst2';

create table dst3 as select substring_index(name3,n'g',2) as [substring_index(name3,n'g',2)] from src;

select data_type,prec from db_attribute where attr_name like '%substring_index%' and class_name='dst3';

create table dst4 as select substring_index(name4,n'g',2) as [substring_index(name4,n'g',2)] from src;

select data_type,prec from db_attribute where attr_name like '%substring_index%' and class_name='dst4';

select substring_index('www.google.com','.',1);

select substring_index('www.google.com','.',2);

select substring_index('www.google.com','.',-2);

select substring_index('www.google.com','.',-8);

select substring_index('www.google.com','.',8);

select substring_index('www.google.com','..',1);

select substring_index('www.google.com','..',-1);

select substring_index('www.google.com','.',1);

select date'2010-11-12',substring_index(date'2010-11-12','-',2);

select datetime'2010-11-12 11:12:13',substring_index(datetime'2010-11-12 11:12:13','AM',1);

select timestamp'2010-11-12 11:12:13',substring_index(timestamp'2010-11-12 11:12:13','/',2);

select 12.34,substring_index(12.34,'.',1);

select 1e10,substring_index(1e10,'0',2);

select substring_index('www.google.com','.',0);

select substring_index('','.',1);

select substring_index('','',1);

select substring_index('www.google.com','w',1);

select substring_index('www.google.com','m',-1);

select substring_index('www.google.com',1,-1);

select substring_index('www.google.com',1,'a');

select substring_index('www.google.com','a','a');

select substring_index(3,'a',1);

select substring_index(2122,n'1',1);

select substring_index(n'2122',1,1);

select substring_index(n'2122','1',1);

select substring_index(n'2122','1',{1});

select substring_index(b'0101110101010',b'11',1);

-- should fail
select substring_index(NULL,1,1);

select name,adr,substring_index(name,'o',1) from tab3 order by name,adr;

select name,adr,substring_index(name,'o',-1) from tab3 order by name,adr;

select name,adr,substring_index(adr,'..',2) from tab3 order by name,adr;

select name,adr,substring_index(adr,'..',-2) from tab3 order by name,adr;

select name,adr,substring_index(adr,name,1) from tab3 order by name,adr;

select name,adr,substring_index(adr,name,-1) from tab3 order by name,adr;

select name,adr,substring_index(adr,name,2) from tab3 order by name,adr;



select name,adr,substring_index(name,'o',1) from tab4 order by name,adr;

select name,adr,substring_index(name,'o',-1) from tab4 order by name,adr;

select name,adr,substring_index(adr,'..',-2) from tab4 order by name,adr;

select name,adr,substring_index(adr,name,1) from tab4 order by name,adr;

select name,adr,substring_index(adr,name,-1) from tab4 order by name,adr;

select name,adr,substring_index(adr,name,2) from tab4 order by name,adr;


select name,adr,substring_index(name,'o',1) from tab5 order by name,adr;

select name,adr,substring_index(name,n'o',-1) from tab5 order by name,adr;

select name,adr,substring_index(adr,'..',-2) from tab5 order by name,adr;

select name,adr,substring_index(adr,name,1) from tab5 order by name,adr;

select name,adr,substring_index(adr,name,-1) from tab5 order by name,adr;

select name,adr,substring_index(adr,name,2) from tab5 order by name,adr;

select d1,substring_index(d1,'/',2) from tab6 order by 1,2;

select d2,substring_index(d2,':',-1) from tab6 order by 1,2;

select f,substring_index(f,2,2) from tab6 order by 1,2;

select t,substring_index(t,2,2) from tab6 order by 1,2;



$varchar,$abc1121abc,$varchar,$1,$int,$2
select substring_index(?,?,?);

$varchar,$abc1121abc,$int,$2
select substring_index(?,1,?);

$varchar,$1,$int,$2
select substring_index(34441231223,?,?);

$datetime,$20091112 12:11:22,$varchar,$:
select substring_index(?,?,-2);

$nchar,$2
select substring_index(98438312,8,?);

$nchar,$2
select substring_index(?,8,1);

drop table tab3;
drop table tab4;
drop table tab5;
drop table tab6;
drop table src;
drop table dst1;
drop table dst2;
drop table dst3;
drop table dst4;


-- should fail : wrong number of params
select substring_index(1,2,3,4);

--1. Test string types
select if(substring_index(cast('abc.def.ghi.jkl' as char(64)), cast('.' as char(1)), 2) = 'abc.def', 'ok', 'nok');
select if(substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast('.' as char varying(32)), 2) = 'abc.def', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast(n'.' as nchar(1)), 2) = n'abc.def', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast(n'.' as nchar varying(32)), 2) = n'abc.def', 'ok', 'nok');
select if(substring_index(cast('abc.def.ghi.jkl' as char(64)), cast('.' as char(1)), -2) = 'ghi.jkl', 'ok', 'nok');
select if(substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast('.' as char varying(32)), -2) = 'ghi.jkl', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast(n'.' as nchar(1)), -2) = n'ghi.jkl', 'ok', 'nok');
select if(substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast(n'.' as nchar varying(32)), -2) = n'ghi.jkl', 'ok', 'nok');

-- error
select substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast('.' as char varying(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast(n'.' as nchar varying(32)), 2);
select substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast('.' as char(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char(64)), cast(n'.' as nchar(32)), 2);
select substring_index(cast(n'abc.def.ghi.jkl' as nchar(64)), cast('.' as char varying(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char varying(64)), cast(n'.' as nchar(32)), 2);
select substring_index(cast(n'abc.def.ghi.jkl' as nchar varying(64)), cast('.' as char(32)), 2);
select substring_index(cast('abc.def.ghi.jkl' as char(64)), cast(n'.' as nchar varying(32)), 2);

-- server side
create table t (c char(32), vc varchar(32), nc nchar(32), vnc nchar varying(32));
insert into t values('abc.def.ghi.jkl', 'ABC.DEF.GHI.JKL', n'abc.def.ghi.jkl', n'ABC.DEF.GHI.JKL');
select if(substring_index(c, '.', 2) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok') from t;
select if(substring_index(vc, '.', 2) = substring_index('ABC.DEF.GHI.JKL', '.', 2), 'ok', 'nok') from t;
select if(substring_index(nc, n'.', 2) = substring_index(n'abc.def.ghi.jkl', n'.', 2), 'ok', 'nok') from t;
select if(substring_index(vnc, n'.', 2) = substring_index(n'ABC.DEF.GHI.JKL', n'.', 2), 'ok', 'nok') from t;
select if(substring_index(c, '.', -2) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok') from t;
select if(substring_index(vc, '.', -2) = substring_index('ABC.DEF.GHI.JKL', '.', -2), 'ok', 'nok') from t;
select if(substring_index(nc, n'.', -2) = substring_index(n'abc.def.ghi.jkl', n'.', -2), 'ok', 'nok') from t;
select if(substring_index(vnc, n'.', -2) = substring_index(n'ABC.DEF.GHI.JKL', n'.', -2), 'ok', 'nok') from t;
drop table t;

-- long separator
select if(substring_index('abcdefghijkabcdefghijkabcdefghijk', 'defg', 2) = 'abcdefghijkabc', 'ok', 'nok');
select if(substring_index('abcdefghijkabcdefghijkabcdefghijk', 'defghij', 2) = 'abcdefghijkabc', 'ok', 'nok');


--2. Test numeric types
select if(substring_index(cast(12123 as short), cast(2 as short), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123 as integer), cast(2 as integer), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123 as bigint), cast(2 as bigint), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as float), cast(2 as float), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as double), cast(2 as double), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as numeric(10,5)), cast(2 as numeric(10,0)), 2) = '121', 'ok', 'nok');
select if(substring_index(cast(12123.456 as monetary), '2', 2) = '$121', 'ok', 'nok');


select if(substring_index(cast(12123 as short), cast(2 as short), -2) = '123', 'ok', 'nok');
select if(substring_index(cast(12123 as integer), cast(2 as integer), -2) = '123', 'ok', 'nok');
select if(substring_index(cast(12123 as bigint), cast(2 as bigint), -2) = '123', 'ok', 'nok');

select if(substring_index(cast(12123.45 as float), cast(2 as float), -2) = '123.45', 'ok', 'nok');
select if(substring_index(cast(12123.456 as double), cast(2 as double), -2) = '123.456', 'ok', 'nok');

select if(substring_index(cast(12123.456 as numeric(10,3)), cast(2 as numeric(10,0)), -2) = '123.456', 'ok', 'nok');
select if(substring_index(cast(12123.456 as monetary), '2', -2) = '123.46', 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary, n numeric(10,3));
insert into t values(12123, 12123, 12123, 12123.45, 12123.456, 12123.456, 12123.456);
select if(substring_index(s, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(i, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(bi, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(f, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(d, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(n, 2, 2) = '121', 'ok', 'nok') from t;
select if(substring_index(m, 2, 2) = '$121', 'ok', 'nok') from t;
select if(substring_index(s, 2, -2) = '123', 'ok', 'nok') from t;
select if(substring_index(i, 2, -2) = '123', 'ok', 'nok') from t;
select if(substring_index(bi, 2, -2) = '123', 'ok', 'nok') from t;
select if(substring_index(f, 2, -2) = '123.45', 'ok', 'nok') from t;
select if(substring_index(d, 2, -2) = '123.456', 'ok', 'nok') from t;
select if(substring_index(n, 2, -2) = '123.456', 'ok', 'nok') from t;
select if(substring_index(m, 2, -2) = '123.46', 'ok', 'nok') from t;
drop table t;


-- Test date/time types
select if(substring_index(date'08/02/2010', '/', 2) = '08/02', 'ok', 'nok');
select if(substring_index(time'09:30:30 AM', ':', 2) = '09:30', 'ok', 'nok');
select if(substring_index(datetime'09:30:30.000 AM 08/02/2010', ' ', 2) = '09:30:30.000 AM', 'ok', 'nok');
select if(substring_index(timestamp'09:30:30 AM 08/02/2010', ' ', 2) = '09:30:30 AM', 'ok', 'nok');

select if(substring_index(date'08/02/2010', '/', -2) = '02/2010', 'ok', 'nok');
select if(substring_index(time'09:30:30 AM', ':', -2) = '30:30 AM', 'ok', 'nok');
select if(substring_index(datetime'09:30:30.000 AM 08/02/2010', ' ', -2) = 'AM 08/02/2010', 'ok', 'nok');
select if(substring_index(timestamp'09:30:30 AM 08/02/2010', ' ', -2) = 'AM 08/02/2010', 'ok', 'nok');

-- server side
create table t (d date, t time, dt datetime, ts timestamp);
insert into t values(date'2010-07-30', time'09:30:30', datetime'2010-07-30 09:30:30', timestamp'2010-07-30 09:30:30');
select if(substring_index(d, '/', 2) = '07/30', 'ok', 'nok') from t;
select if(substring_index(t, ':', 2) = '09:30', 'ok', 'nok') from t;
select if(substring_index(dt, ' ', 2) = '09:30:30.000 AM', 'ok', 'nok') from t;
select if(substring_index(ts, ' ', 2) = '09:30:30 AM', 'ok', 'nok') from t;
select if(substring_index(d, '/', -2) = '30/2010', 'ok', 'nok') from t;
select if(substring_index(t, ':', -2) = '30:30 AM', 'ok', 'nok') from t;
select if(substring_index(dt, ' ', -2) = 'AM 07/30/2010', 'ok', 'nok') from t;
select if(substring_index(ts, ' ', -2) = 'AM 07/30/2010', 'ok', 'nok') from t;
drop table t;

--4. Check the range of count
select if(substring_index('abc.def.ghi.jkl', '.', 4) = substring_index('abc.def.ghi.jkl', '.', 5), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', -4) = substring_index('abc.def.ghi.jkl', '.', -5), 'ok', 'nok');
select if(length(substring_index('abc.def.ghi.jkl', '.', 0)) = 0, 'ok', 'nok');
select if(substring_index(n'abc.def.ghi.jkl', n'.', 4) = substring_index(n'abc.def.ghi.jkl', n'.', 5), 'ok', 'nok');
select if(substring_index(n'abc.def.ghi.jkl', n'.', -4) = substring_index(n'abc.def.ghi.jkl', n'.', -5), 'ok', 'nok');
select if(length(substring_index(n'abc.def.ghi.jkl', n'.', 0)) = 0, 'ok', 'nok');

-- should be no assertion
select substring_index(n'123123', n'2', 0);

-- rounding
select if(substring_index('abc.def.ghi.jkl', '.', cast(1.5 as float)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(1.5 as double)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-1.5 as float)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-1.5 as double)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(2.4 as float)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(2.4 as double)) = substring_index('abc.def.ghi.jkl', '.', 2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-2.4 as float)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', cast(-2.4 as double)) = substring_index('abc.def.ghi.jkl', '.', -2), 'ok', 'nok');

-- error on numeric/monetary
--TBD

--5. Exceptions
-- return NULL
select if(substring_index(null, '.', -1) is null, 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', null, -1) is null, 'ok', 'nok');
select if(substring_index('abc.def.ghi.jkl', '.', null) is null, 'ok', 'nok');

-- empty separator
select if(length(substring_index('abc.def.ghi.jkl', '', 2)) = 0, 'ok', 'nok');
-- should be no assertion
select substring_index('abc.def.ghi.jkl', '', 2);

--6. Test host variable
-- success
$varchar, $abc.def.ghi.jkl, $varchar, $., $int, $2, $varchar, $abc.def
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$varchar, $abc.def.ghi.jkl, $varchar, $., $varchar, $-2, $varchar, $ghi.jkl
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$varchar, $abcdefghijkabcdefghijkabcdefghijk, $varchar, $defg, $int, $2, $varchar, $abcdefghijkabc
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$varchar, $abcdefghijkabcdefghijkabcdefghijk, $varchar, $defghij, $int, $2, $varchar, $abcdefghijkabc
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$int, $12123, $int, $2, $int, $2, $varchar, $121
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$numeric[10,4], $12123.456, $int, $2, $int, $2, $varchar, $121
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$float, $12123.456f, $int, $2, $int, $2, $varchar, $121
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$double, $12123.456e0, $int, $2, $int, $2, $varchar, $121
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$monetary, $12123.456, $int, $2, $int, $2, $varchar, $121
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$int, $12123, $int, $2, $int, $-2, $varchar, $123
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$numeric[10,4], $12123.456, $int, $2, $int, $-2, $varchar, $123.456
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$float, $12123.45f, $int, $2, $int, $-2, $varchar, $123.45
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$double, $12123.456e0, $int, $2, $int, $-2, $varchar, $123.456
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$monetary, $12123.456, $int, $2, $int, $-2, $varchar, $123.456
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$date, $2010-08-02, $varchar, $/, $int, $2, $varchar, $08/02
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$time, $09:30:30, $varchar, $:, $int, $2, $varchar, $09:30
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$date, $2010-08-02, $varchar, $/, $int, $-2, $varchar, $02/2010
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$time, $09:30:30, $varchar, $:, $int, $-2, $varchar, $30:30 AM
select if(substring_index(?, ?, ?) = ?, 'ok', 'nok');

$varchar, $abc.def.ghi.jkl, $varchar, $., $int, $0, $int, $0
select if(length(substring_index(?, ?, ?)) = ?, 'ok', 'nok');

$int, $4, $int, $5
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$int, $-4, $int, $-5
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$numeric, $1.5, $numeric, $2.0 
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$float, $1.5f, $float, $2.0f
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$double, $1.5e0, $double, $2e0
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$numeric, $2.4, $numeric, $2.0 
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$float, $2.4f, $float, $2.0f
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$double, $2.4e0, $double, $2e0
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$numeric, $-1.5, $numeric, $-2.0 
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$float, $-1.5f, $float, $-2.0f
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$double, $-1.5e0, $double, $-2e0
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$numeric, $-2.4,$numeric, $-2.0 
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$float, $-2.4f, $float, $-2.0f
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

$double, $-2.4e0, $double, $-2e0
select if(substring_index('abc.def.ghi.jkl', '.', ?) = substring_index('abc.def.ghi.jkl', '.', ?), 'ok', 'nok');

-- failure
$varnchar, $abc.def.ghi.jkl, $varnchar, $., $int, $2
select substring_index(?, ?, ?);

$varchar, $abc.def.ghi.jkl, $varchar, $., $varchar, $a
select substring_index(?, ?, ?);

$varchar, $abc.def.ghi.jkl, $varchar, $.,$binary, $0b1111
select substring_index(?, ?, ?);

$varchar, $abc.def.ghi.jkl, $varchar, $., $date, $2010-08-02
select substring_index(?, ?, ?);

$varchar, $abc.def.ghi.jkl, $varchar, $., $time , $09:30:30
select substring_index(?, ?, ?);

$varchar, $abc.def.ghi.jkl, $varchar, $., $datetime, $2010-08-02 09:30:30.000
select substring_index(?, ?, ?);

$varchar, $abc.def.ghi.jkl, $varchar, $., $timestamp, $2010-08-02 09:30:30
select substring_index(?, ?, ?);
