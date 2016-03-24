--TEST: pass string value of numeric format as an argument



--TEST: normal values
select bin('366');
select bin('3652424');
select bin('3652499');
select bin('2652466');


--TEST: pass marginal values
--TEST: max(smallint)
select bin('32767');
--TEST: min(short)
select bin('-32768');

--TEST: max(int)
select bin('2147483647');
--TEST: min(int)
select bin('-2147483648');

--TEST: max(bigint)
select bin('9223372036854775807');
--TEST: min(bigint)
select bin('-9223372036854775808');

--TEST: max(float)
select bin('+1.175494351E-38');
select bin('+3.402823466E+38');
--TEST: min(float)
select bin('-3.402823466E+38');
select bin('-1.175494351E-38');

--TEST: max(double)
select bin('2.2250738585072014E-308');
select bin('1.7976931348623157E+308');
--TEST: min(double)
select bin('-1.7976931348623157E+308');
select bin('-2.2250738585072014E-308');


--TEST: exceptional values
select bin('0');
select bin('00.000');
select bin('-1');
select bin('10000000000000000000000000000000000');
select bin('24*60*60');
select bin('1.23');
select bin();
select bin(null);
select bin('480', '200');
select bin(?);

