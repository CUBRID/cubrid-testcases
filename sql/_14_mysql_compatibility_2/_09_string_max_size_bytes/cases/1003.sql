--+ holdcas on;
-- test cases on system parameter holding the maximum size of a string
-- (CHAR, NCHAR, VARCHAR , VARNCHAR, BIT, VARBIT) when created with :
-- SPACE, REPEAT, GROUP_CONCAT, CONCAT, CONCAT_WS, STRCAT ,INSERT, + (PLUS )




-- CONCAT
set system parameters 'string_max_size_bytes=64';
select concat('123456789012345678901234567890','1234567890123456789012345678901234');
select concat('123456789012345678901234567890','12345678901234567890123456789012345');


select concat(n'123456789012345678901234567890',n'12');
select concat(n'123456789012345678901234567890',n'123');

select concat(b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'1010101010101010');
select concat(b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'101010101100110011110000',
							b'10101010101010101');							


create table t1 (s1 char(32),s2 varchar(32), s3 national char varying(32), b1 bit varying(32), b2 bit(32));
insert into t1 values ('1234567890','1234567890',n'12345',b'10101010110011001111000010101010',b'10101010');

select concat(s1,s1) from t1;
select concat(s1,s1,'1') from t1;


select concat(s2,s2,s2,s2,s2,s2,'1234') from t1;
select concat(s2,s2,s2,s2,s2,s2,'12345') from t1;

select concat(s3,s3,s3,s3,s3,s3,n'12') from t1;
select concat(s3,s3,s3,s3,s3,s3,n'123') from t1;

select concat(b1,b1,b1,b1,b1,b1,b1,b1) from t1;
select concat(b1,b1,b1,b1,b1,b1,b1,b1,b'1') from t1;

select concat(b2,b2,b2,b2,b2,b2,b2,b2) from t1;
select concat(b2,b2,b2,b2,b2,b2,b2,b2,b'1') from t1;


drop t1;




set system parameters 'string_max_size_bytes=10000000';

commit;
--+ holdcas off;
