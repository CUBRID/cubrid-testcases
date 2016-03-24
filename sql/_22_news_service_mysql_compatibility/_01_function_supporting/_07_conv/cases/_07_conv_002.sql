--test
SELECT CONV(10+'10'+'10'+0xa,10,10);
--test
SELECT CONV(10+'10'+'10',10,10);
--test
SELECT CONV(10+'10'+'10',2,10);
--test
SELECT CONV(10+'10'+'10',3,10);
--test
SELECT CONV(10+'10'+'10',4,10);
--test
SELECT CONV(10+'10'+'10',4,null);
--test
select conv(b'10', 36, 10);
--test
select conv(b'10', 2, 10);
--test
select conv(b'10', -10, 10);
--test
select conv(b'10', 1, 10);
--test 64bit
select conv(B'1111111111111111111111111111111111111111111111111111111111111111', 10, 10);
--test 65bit
select conv(B'11111111111111111111111111111111111111111111111111111111111111111', 10, 10);

