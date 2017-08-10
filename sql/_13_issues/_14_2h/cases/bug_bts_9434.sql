SELECT CONV('9223372036854775807',16,2);
SELECT CONV('9223372036854775807',10,2);
SELECT CONV('9223372036854775808',10,2);
SELECT CONV('9223372036854775808',-10,2);
SELECT CONV('-9223372036854775808',-10,2);
SELECT CONV('-9223372036854775809',-10,2);
SELECT CONV(9223372036854775807,16,2);
SELECT CONV(9223372036854775807,20,2);
SELECT CONV(-1,10,2);
SELECT CONV(-2,10,2);
SELECT CONV(-1,-10,2);
SELECT CONV(-2,-10,2);
SELECT CONV('abc',10,2);
SELECT CONV('-abc',-10,2);
SELECT CONV('abc',16,2);
SELECT CONV('-abc',-16,2);
--test invalid part
SELECT CONV('&$',16,2);
SELECT CONV('fa&$',16,2);
SELECT CONV(123.45,10,20);
SELECT CONV('12345&&%',10,20);
SELECT CONV('f.#*$',16,2); --invalid
--test valid against base
SELECT CONV('f.abcd',16,2); --valid
SELECT CONV('f.abcd',15,2); --invalid
SELECT CONV('f.qqp',16,2); --invalid
SELECT CONV('8338.6669',9,2); --invalid
SELECT CONV('f.fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff',16,2); --valid
--test upper case
SELECT CONV('FbAd.abcd',16,2); --valid
--check space for now.
--#111111111111111111111111111111111111111111111111111111111111111
SELECT CONV('                   922337203685477',-16,-2);
--#-1000000000000000000000000000000000000000000000000000000000000000
SELECT CONV('                 		9223372036854775807',-16,-2);
--test max
SELECT CONV('1111111111111111111111111111111111111111111111111111111111111111', 2, 16);
SELECT CONV('FFFFFFFFFFFFFFFF', 16, -10);
SELECT CONV('FFFFFFFFFFFFFFFF', 16, 10);
SELECT CONV('FFFFFFFFFFFFFFFF', 16, 8);
--test decimal point
SELECT CONV('FF.FFFFFF.FFFFFFFF', 16, 8);
--test table
drop table if exists q;
create table q (s varchar, c char(1), i bigint);
insert into q values
	('a', 'b', 97),
	('b', 'a', 97),
	('x', 'y', 120),
	('y', 'x', 120),
	('FF', 'x', 10),
	('7A', 'z', 10);
SELECT CONV(s, 36, 10), CONV(c, 36, 2), CONV(i, 10, 16) from q;	
SELECT CONV(s, 16, 10), CONV(c, 16, 2), CONV(i, 10, 16) from q;
SELECT CONV(s, 36, 10), CONV(c, 36, 2), CONV(i, 9, 16) from q;

drop table if exists q;
