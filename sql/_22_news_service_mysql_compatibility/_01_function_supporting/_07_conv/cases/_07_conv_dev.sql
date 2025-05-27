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

create table bits (
	_bit bit, 
	_bit1 bit(1), 
	_bit4 bit(4), 
	_bit8 bit(8), 
	_bit16 bit(16), 
	_bit64 bit(64), 
	_bitv bit varying);

create table bases (
	_base int);

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

-- bits
insert into bits values (B'0', B'0', B'0000', B'00000000', B'0000000000000000', B'0000000000000000000000000000000000000000000000000000000000000000', B'0000000000000');
insert into bits values (B'1', B'1', B'1111', B'11111111', B'1111111111111111', B'1111111111111111111111111111111111111111111111111111111111111111', B'1111111111111');
insert into bits values (B'0', B'0', B'1010', B'10101010', B'1010101010101010', B'1010101010101010101010101010101010101010101010101010101010101010', B'0101010101010');
insert into bits values (B'1', B'1', B'0011', B'00001111', B'0000111100001111', B'0000111100001111000011110000111100001111000011110000111100001111', B'0111100001111');
insert into bits values (B'0', B'1', B'0110', B'01001011', B'0000000010011011', B'0000111100001111000000000000111100001111000011110000111100001111', B'01001010100010000000000000000000011001010101');
insert into bits values (null, null, null, null, null, null, null);

--  bases
insert into bases values (-37);
insert into bases values (-36);
insert into bases values (-16);
insert into bases values (-10);
insert into bases values (-2);
insert into bases values (-1);
insert into bases values (1);
insert into bases values (2);
insert into bases values (10);
insert into bases values (16);
insert into bases values (36);
insert into bases values (37);

-----------------------------------------------------
-- CONV function tests
-----------------------------------------------------
-- argument tests
select 'conv argument tests';
select conv;
select conv();
select conv(0);
select conv(0, 0);
select conv(0, 0, 0, 0);

select conv(null, null, null);
select conv(10, null, null);
select conv(null, 10, null);
select conv(10, 10, null);
select conv(null, null, 10);
select conv(10, null, 10);
select conv(null, 10, 10);

-- numbers tests
select 'conv numbers test';
select _int,           _base, conv(conv(_int,           case when _int           < 0 then -10 else 10 end, _base), _base, case when _int           < 0 then -10 else 10 end), conv(_int,           10, _base) from numerics, bases order by _int, _base;
select _smallint,      _base, conv(conv(_smallint,      case when _smallint      < 0 then -10 else 10 end, _base), _base, case when _smallint      < 0 then -10 else 10 end), conv(_smallint,      10, _base) from numerics, bases order by _smallint, _base;
select _bigint,        _base, conv(conv(_bigint,        case when _bigint        < 0 then -10 else 10 end, _base), _base, case when _bigint        < 0 then -10 else 10 end), conv(_bigint,        10, _base) from numerics, bases order by _bigint, _base;
select _numeric,       _base, conv(conv(_numeric,       case when _numeric       < 0 then -10 else 10 end, _base), _base, case when _numeric       < 0 then -10 else 10 end), conv(_numeric,       10, _base) from numerics, bases order by _numeric, _base;
select _numeric_4_2,   _base, conv(conv(_numeric_4_2,   case when _numeric_4_2   < 0 then -10 else 10 end, _base), _base, case when _numeric_4_2   < 0 then -10 else 10 end), conv(_numeric_4_2,   10, _base) from numerics, bases order by _numeric_4_2, _base;
select _numeric_18_5,  _base, conv(conv(_numeric_18_5,  case when _numeric_18_5  < 0 then -10 else 10 end, _base), _base, case when _numeric_18_5  < 0 then -10 else 10 end), conv(_numeric_18_5,  10, _base) from numerics, bases order by _numeric_18_5, _base;
select _numeric_30_10, _base, conv(conv(_numeric_30_10, case when _numeric_30_10 < 0 then -10 else 10 end, _base), _base, case when _numeric_30_10 < 0 then -10 else 10 end), conv(_numeric_30_10, 10, _base) from numerics, bases order by _numeric_30_10, _base;
select _float,         _base, conv(conv(_float,         case when _float         < 0 then -10 else 10 end, _base), _base, case when _float         < 0 then -10 else 10 end), conv(_float,         10, _base) from numerics, bases order by _float, _base;
select _double,        _base, conv(conv(_double,        case when _double        < 0 then -10 else 10 end, _base), _base, case when _double        < 0 then -10 else 10 end), conv(_double,        10, _base) from numerics, bases order by _double, _base;
select _monetary,      _base, conv(conv(_monetary,      case when _monetary      < 0 then -10 else 10 end, _base), _base, case when _monetary      < 0 then -10 else 10 end), conv(_monetary,      10, _base) from numerics, bases order by _monetary, _base;

-- bit tests
select 'conv bits test';
select _bit, 	conv(_bit,      2,  16), conv(_bit,   2, 2), conv(conv(_bit,      2,  16),  16, 2) from bits order by _bit;
select _bit1, 	conv(_bit1,    10,  16), conv(_bit1,  2, 2), conv(conv(_bit1,    10,  16),  16, 2) from bits order by _bit1;
select _bit4, 	conv(_bit4,    -2,  16), conv(_bit4,  2, 2), conv(conv(_bit4,    -2,  16),  16, 2) from bits order by _bit4;
select _bit8, 	conv(_bit8,   -10,  16), conv(_bit8,  2, 2), conv(conv(_bit8,   -10,  16),  16, 2) from bits order by _bit8;
select _bit16, 	conv(_bit16,    2, -16), conv(_bit16, 2, 2), conv(conv(_bit16,    2, -16), -16, 2) from bits order by _bit16;
select _bit64, 	conv(_bit64,    2,  16), conv(_bit64, 2, 2), conv(conv(_bit64,    2,  16),  16, 2) from bits order by _bit64;
select _bit64, 	conv(_bit64,    2, -16), conv(_bit64, 2, 2), conv(conv(_bit64,    2, -16), -16, 2) from bits order by _bit64;
select _bitv, 	conv(_bitv,     2,  16), conv(_bitv,  2, 2), conv(conv(_bitv,     2,  16),  16, 2) from bits order by _bitv;
select _bitv, 	conv(_bitv,     2, -16), conv(_bitv,  2, 2), conv(conv(_bitv,     2, -16), -16, 2) from bits order by _bitv;

-- prepared statement
prepare st from 'select conv(?, ?, ?)';
execute st using null, null, null;
execute st using 123, 10, 10;
execute st using '123', 10, 10;
execute st using b'10', 10, 10;
deallocate prepare st;

-- const folding
select conv(null, null, null);
select conv(123, 10, 10);
select conv(123.45, 10, 10);
select conv('123', 10, 10);
select conv(b'10', 10, 10);

-- other tests
select conv('&', 36, 36);

-- cleanup
drop table numerics;
drop table bits;
drop table bases;
