--TEST: pass out-of-range values to the parameter



--TEST: pass out-of-range values
--TEST: > max(smallint)
select bin(32768), if(bin(32768) = '1000000000000000', 'ok', 'nok');
--TEST: < min(short)
select bin(-32769), if(bin(-32769) = '1111111111111111111111111111111111111111111111110111111111111111', 'ok', 'nok');

--TEST: > max(int)
select bin(2147483648), if(bin(2147483648) = '10000000000000000000000000000000', 'ok', 'nok');
--TEST: < min(int)
select bin(-2147483649), if(bin(-2147483649) = '1111111111111111111111111111111101111111111111111111111111111111', 'ok', 'nok');

--TEST: error, > max(bigint)
select bin(922337203685477580678);
--TEST: error, < min(bigint)
select bin(-922337203685477580834543);

--TEST: > max(float)
select bin(+1.175494351E-39);
select bin(+3.402823466E+40);
--TEST: < min(float)
select bin(-3.402823466E+41);
select bin(-1.175494351E-42);

--TEST: > max(double)
select bin(2.2250738585072014E-308);
select bin(1.7976931348623157E+310);
--TEST: < min(double)
select bin(-1.7976931348623157E+400);
select bin(-2.2250738585072014E-800);



