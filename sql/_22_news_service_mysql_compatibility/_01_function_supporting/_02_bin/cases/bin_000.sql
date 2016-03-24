--normal test cases


--TEST: normal test cases
SELECT bin(730669);
SELECT bin(719528);
SELECT bin(365);
SELECT bin(366);
SELECT bin(-1);
select bin(100000000);

--TEST: test for valid input
select bin(731945), if (bin(731945) = '10110010101100101001', 'ok', 'nok');
--TEST: test with expressions
select bin(731945+10), if (bin(731945+10) = '10110010101100110011', 'ok', 'nok');
select bin(731945-10), if (bin(731945-10) = '10110010101100011111', 'ok', 'nok');
select bin(731945+365), if (bin(731945+365) = '10110010110010010110', 'ok', 'nok');
select bin(731945+365*2+1), if (bin(731945+365*2+1) = '10110010111000000100', 'ok', 'nok');
select bin(-123.456 * (-823748923)), if (bin(-123.456 * (-823748923)) = '1011110101101100110010011011000011110', 'ok', 'nok');
--TEST: test with string value of numeric format
select bin(-123.456 * (-823748923)), if (bin('-123.456' * ('-823748923')) = '1011110101101100110010011011000011110', 'ok', 'nok');
select bin(731945), if (bin('731945') = '10110010101100101001', 'ok', 'nok');

