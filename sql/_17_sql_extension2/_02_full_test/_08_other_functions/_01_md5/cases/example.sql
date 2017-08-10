--cases from dev


select md5('cubrid');
select md5(255);
select md5('01/01/2010');
select md5(cast('2010-01-01' as DATE));
SELECT MD5('testing');


--1. Test string types
select if(md5('a') = '0cc175b9c0f1b6a831c399e269772661', 'ok', 'nok');
select if(md5('abcdefghijklmnopqrstuvwxyz') = 'c3fcd3d76192e4007dfb496cca67e13b', 'ok', 'nok');
select if(md5('') = 'd41d8cd98f00b204e9800998ecf8427e', 'ok', 'nok');
select if(md5(null) is null, 'ok', 'nok');

select if(md5(n'a') = md5('a'), 'ok', 'nok');
select if(md5(n'abcdefghijklmnopqrstuvwxyz') = md5('abcdefghijklmnopqrstuvwxyz'), 'ok', 'nok');
select if(md5(n'') = md5(''), 'ok', 'nok');

-- server side
create table t (c char(128), vc varchar(128), nc nchar(128), vnc nchar varying(128));
insert into t values('a', 'a', n'a', n'a');
select if(md5(c) = md5(cast('a' as char(128))), 'ok', 'nok') from t;
select if(md5(vc) = md5(cast('a' as char varying(128))), 'ok', 'nok') from t;
select if(md5(nc) = md5(cast(n'a' as nchar(128))), 'ok', 'nok') from t;
select if(md5(vnc) = md5(cast(n'a' as nchar varying(128))), 'ok', 'nok') from t;
drop table t;

--2. Test numeric types (conversion)
select if(md5('1') = md5(cast(1 as short)), 'ok', 'nok');
select if(md5('1') = md5(cast(1 as integer)), 'ok', 'nok');
select if(md5('1') = md5(cast(1 as bigint)), 'ok', 'nok');
select if(md5('1.1') = md5(cast(1.1 as float)), 'ok', 'nok');
select if(md5('1.1') = md5(cast(1.1 as double)), 'ok', 'nok');
select if(md5('1.1') = md5(cast(1.1 as numeric(10,1))), 'ok', 'nok');
select if(md5('$1.1') = md5(cast(1.1 as monetary)), 'ok', 'nok');

--3. Test bit types (conversion)
select if(md5(b'1') = md5('8'), 'ok', 'nok');
select if(md5(cast(b'1' as bit(8))) = md5('80'), 'ok', 'nok');



