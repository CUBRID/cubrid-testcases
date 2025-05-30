--+ holdcas on;
set system parameters 'no_backslash_escapes=no';

-- tables
create table numerics (
	_int int, 
	_smallint smallint, 
	_bigint bigint, 
	_numeric numeric, 
	_numeric_4_2 numeric(4,2), 
	_numeric_18_5 numeric(18,5), 
	_numeric_30_10 numeric(30,10), 
	_float float, 
	_double double, 
	_monetary monetary);

create table datetimes (
	_date date, 
	_time time, 
	_datetime datetime, 
	_timestamp timestamp);

create table bits (
	_bit bit, 
	_bit1 bit(1), 
	_bit4 bit(4), 
	_bit8 bit(8), 
	_bit16 bit(16), 
	_bit64 bit(64), 
	_bitv bit varying);

create table chars (
	_char1 char(1), 
	_char4 char(4), 
	_char64 char(64), 
	_varchar128 varchar(128), 
	_str string, 
	_nchar1 nchar(1), 
	_nchar4 nchar(4), 
	_nchar64 nchar(64), 
	_varnchar128 nchar varying(128));


-- numbers
insert into numerics values (-2147483648, -32768, -9223372036854775808, -999999999999999, -99.99, -9999999999999.99999, -99999999999999999999.9999999999, -1.0e+37, -1.0e+308, -1.0e+308);
insert into numerics values (+2147483647, +32767, +9223372036854775807, +999999999999999, +99.99, +9999999999999.99999, +99999999999999999999.9999999999, +1.0e+37, +1.0e+308, +1.0e+308);
insert into numerics values (-1, -1, -1, -1, -0.01, -0.00001, -0.0000000001, -1.0e-37, -3.0e-308, -3.0e-308);
insert into numerics values (+1, +1, +1, +1, +0.01, +0.00001, +0.0000000001, +1.0e-37, +3.0e-308, +3.0e-308);
insert into numerics values (-4000, -15000, -1234567890123456, -123456789012345, -16.55, -1234123.91231, -42123412.1259, -1234.567e+1, -54321.09e-1, -123000.44);
insert into numerics values (+4000, +15000, +1234567890123456, +123456789012345, +16.55, +1234123.91231, +42123412.1259, +1234.567e+1, +54321.09e-1, +123000.44);
insert into numerics values (null, null, null, null, -12.49, null, null, null, null, null);
insert into numerics values (null, null, null, null, +12.49, null, null, null, null, null);
insert into numerics values (null, null, null, null, -12.51, null, null, null, null, null);
insert into numerics values (null, null, null, null, +12.51, null, null, null, null, null);
insert into numerics values (null, null, null, null, null, null, null, null, null, null);

-- datetimes
insert into datetimes values (DATE '01/01/0001', TIME '00:00:00', DATETIME '00:00:00.000 01/01/0001', TIMESTAMP '00:00:01 01/01/1971');
insert into datetimes values (DATE '12/31/9999', TIME '23:59:59', DATETIME '23:59:59.999 12/31/9999', TIMESTAMP '03:14:07 01/19/2038');
insert into datetimes values (DATE '11/01/2011', TIME '11:45:33', DATETIME '11:45:33.123 11/01/2011', TIMESTAMP '11:45:33 11/01/2011');
insert into datetimes values (DATE '09/03/1993', TIME '02:00:00', DATETIME '02:00:00.987 09/03/1993', TIMESTAMP '02:00:00 09/03/1993');
insert into datetimes values (null, null, null, null);

-- bits
insert into bits values (B'0', B'0', B'0000', B'00000000', B'0000000000000000', B'0000000000000000000000000000000000000000000000000000000000000000', B'0000000000000');
insert into bits values (B'1', B'1', B'1111', B'11111111', B'1111111111111111', B'1111111111111111111111111111111111111111111111111111111111111111', B'1111111111111');
insert into bits values (B'0', B'0', B'1010', B'10101010', B'1010101010101010', B'1010101010101010101010101010101010101010101010101010101010101010', B'0101010101010');
insert into bits values (B'1', B'1', B'0011', B'00001111', B'0000111100001111', B'0000111100001111000011110000111100001111000011110000111100001111', B'0111100001111');
insert into bits values (B'0', B'1', B'0110', B'01001011', B'0000000010011011', B'0000111100001111000000000000111100001111000011110000111100001111', B'01001010100010000000000000000000011001010101');
insert into bits values (null, null, null, null, null, null, null);

-- chars
insert into chars values (
	'\n',
	'\n\r\t\\',
	'\n\r\t\\',
	'\n\r\t\\',
	'\n\r\t\\',
	N'\n',
	N'\n\r\t\\',
	N'\n\r\t\\',
	N'\n\r\t\\');

insert into chars values (
	'T',
	'The',
	'The quick brown fox jumps over the lazy dog.   ',
	'The quick brown fox jumps over the lazy dog.   ',
	'The quick brown fox jumps over the lazy dog.   ',
	N'T',
	N'The',
	N'The quick brown fox jumps over the lazy dog.   ',
	N'The quick brown fox jumps over the lazy dog.   ');

insert into chars values (
	'a',
	'abcd',
	'abcdefghijklmnopqrstuvwxyz\n0123456789`~!@#$%^&*()-_=+\\|/?.>,<":;',
	'abcdefghijklmnopqrstuvwxyz\n0123456789`~!@#$%^&*()-_=+\\|/?.>,<":;]}[{',
	'abcdefghijklmnopqrstuvwxyz\n0123456789`~!@#$%^&*()-_=+\\|/?.>,<":;]}[{',
	N'a',
	N'abcd',
	N'abcdefghijklmnopqrstuvwxyz\n0123456789`~!@#$%^&*()-_=+\\|/?.>,<":;',
	N'abcdefghijklmnopqrstuvwxyz\n0123456789`~!@#$%^&*()-_=+\\|/?.>,<":;]}[{');

insert into chars values (null, null, null, null, null, null, null, null, null);

-----------------------------------------------------
-- HEX function tests
-----------------------------------------------------
-- argument tests
select 'hex argument tests';
select hex;
select hex();
select hex(0, 0);
select hex(0, 0, 0);
select hex(null);

-- numbers tests
select 'hex numbers test';
select _int,           hex(_int),           conv(hex(_int), 16, -10) from numerics order by _int;
select _smallint,      hex(_smallint),      conv(hex(_smallint), 16, -10) from numerics order by _smallint;
select _bigint,        hex(_bigint),        conv(hex(_bigint), 16, -10) from numerics order by _bigint;
select _numeric,       hex(_numeric),       conv(hex(_numeric), 16, -10) from numerics order by _numeric;
select _numeric_4_2,   hex(_numeric_4_2),   conv(hex(_numeric_4_2), 16, -10) from numerics order by _numeric_4_2;
select _numeric_18_5,  hex(_numeric_18_5),  conv(hex(_numeric_18_5), 16, -10) from numerics order by _numeric_18_5;
select _numeric_30_10, hex(_numeric_30_10), conv(hex(_numeric_30_10), 16, -10) from numerics order by _numeric_30_10;
select _float,         hex(_float),         conv(hex(_float), 16, -10) from numerics order by _float;
select _double,        hex(_double),        conv(hex(_double), 16, -10) from numerics order by _double;
select _monetary,      hex(_monetary),      conv(hex(_monetary), 16, -10) from numerics order by _monetary;

-- datetimes tests
select 'hex datetimes test';
select _date, hex(_date) from datetimes order by _date;
select _time, hex(_time) from datetimes order by _time;
select _datetime, hex(_datetime) from datetimes order by _datetime;
select _timestamp, hex(_timestamp) from datetimes order by _timestamp;

-- bit tests
select 'hex bits test';
select _bit, hex(_bit) from bits order by _bit;
select _bit1, hex(_bit1) from bits order by _bit1;
select _bit4, hex(_bit4) from bits order by _bit4;
select _bit8, hex(_bit8) from bits order by _bit8;
select _bit16, hex(_bit16) from bits order by _bit16;
select _bit64, hex(_bit64) from bits order by _bit64;
select _bitv, hex(_bitv) from bits order by _bitv;

-- chars tests
select 'hex chars test';
select _char1, hex(_char1) from chars order by _char1;
select _char4, hex(_char4) from chars order by _char4;
select _char64, hex(_char64) from chars order by _char64;
select _varchar128, hex(_varchar128) from chars order by _varchar128;
select _str, hex(_str) from chars order by _str;
select _nchar1, hex(_nchar1) from chars order by _nchar1;
select _nchar4, hex(_nchar4) from chars order by _nchar4;
select _nchar64, hex(_nchar64) from chars order by _nchar64;
select _varnchar128, hex(_varnchar128) from chars order by _varnchar128;

-- stress tests
select 'hex stress tests';
select hex(hex(_int)) from numerics order by _int;
select length(hex(_int))*512, length(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(_int))))))))))) from numerics order by _int;
select length(hex(_str))*8192, length(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(_str))))))))))))))) from chars order by _str;
select hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(hex(_str)))))))))))))) from chars order by _str;

-- prepared statements
prepare st from 'select hex(?)';
execute st using null;
execute st using 123;
execute st using 123.45;
execute st using b'10';
execute st using '123';
deallocate prepare st;

-- const folding
select hex(null);
select hex(123);
select hex(123.45);
select hex('10');
select hex('123');

-- commit
commit;

-- cleanup
drop table chars;
drop table numerics;
drop table datetimes;
drop table bits;

-- restore state
--+ holdcas off;
set system parameters 'no_backslash_escapes=yes';

