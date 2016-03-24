--TEST: pass marginal and exceptional values to the parameter



--TEST: normal values
select bin(366), if (bin(366) = '101101110', 'ok', 'nok');
select bin(3652424), if (bin(3652424) = '1101111011101101001000', 'ok', 'nok');
select bin(3652499), if (bin(3652499) = '1101111011101110010011', 'ok', 'nok');
select bin(2652466), if (bin(2652466) = '1010000111100100110010', 'ok', 'nok');


--TEST: pass marginal values
--TEST: max(smallint)
select bin(32767), if (bin(32767) = '111111111111111', 'ok', 'nok');
--TEST: min(short)
select bin(-32768), if (bin(-32768) = '1111111111111111111111111111111111111111111111111000000000000000', 'ok', 'nok');

--TEST: max(int)
select bin(2147483647), if (bin(2147483647) = '1111111111111111111111111111111', 'ok', 'nok');
--TEST: min(int)
select bin(-2147483648), if (bin(-2147483648) = '1111111111111111111111111111111110000000000000000000000000000000', 'ok', 'nok');

--TEST: max(bigint)
select bin(9223372036854775807), if (bin(9223372036854775807) = '111111111111111111111111111111111111111111111111111111111111111', 'ok', 'nok');
--TEST: min(bigint)
select bin(-9223372036854775808), if (bin(-9223372036854775808) = '1000000000000000000000000000000000000000000000000000000000000000', 'ok', 'nok');

--TEST: max(float)
select bin(+1.175494351E-38);
select bin(+3.402823466E+38);
--TEST: min(float)
select bin(-3.402823466E+38);
select bin(-1.175494351E-38);

--TEST: max(double)
select bin(2.2250738585072014E-308);
select bin(1.7976931348623157E+308);
--TEST: min(double)
select bin(-1.7976931348623157E+308);
select bin(-2.2250738585072014E-308);


--TEST: exceptional values
select bin(0), if (bin(0) = '0', 'ok', 'nok');
select bin(00.000), if(bin(00.000) = '0', 'ok', 'nok');
select bin(-1), if (bin(-1) = '1111111111111111111111111111111111111111111111111111111111111111', 'ok', 'nok');
select bin(10000000000000000000000000000000000), if (bin(10000000000000000000000000000000000) = '1111111111111111111111111111111111111111111111111111111111111111', 'ok', 'nok');
select bin(24*60*60), if (bin(24*60*60) = '10101000110000000', 'ok', 'nok');
select bin(1.23), if (bin(1.23) = '1', 'ok', 'nok');
select bin();
select bin(null), if (bin(null) is null, 'ok', 'nok');
select bin(480, 200);
select bin(?);

