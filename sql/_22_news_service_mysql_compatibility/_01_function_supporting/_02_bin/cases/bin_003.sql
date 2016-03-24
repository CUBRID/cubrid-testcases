--TEST: use function and expressions as an argument


--TEST: to_days function
select bin(to_days('1878-12-12')), if(bin(to_days('1878-12-12')) = '10100111100010111111', 'ok', 'nok');
select bin(to_days(date'0001-01-01')), if(bin(to_days(date'0001-01-01')) = '101101110', 'ok', 'nok');
select bin(to_days(timestamp'1999-12-31 20:12:34')), if(bin(to_days(timestamp'1999-12-31 20:12:34')) = '10110010010101110100', 'ok', 'nok');
select bin(to_days(addtime('9999-03-15 12:30:12:222', '1:1:1'))), if(bin(to_days(addtime('9999-03-15 12:30:12:222', '1:1:1'))) = '1101111011101000100101', 'ok', 'nok');
select bin(to_days(from_days(to_days(adddate('1999-10-10 12:30:12:222', 12))))), if(bin(to_days(from_days(to_days(adddate('1999-10-10 12:30:12:222', 12))))) = '10110010010100101110', 'ok', 'nok');


--TEST: numeric functions
select bin(floor(13579.27283)), if(bin(floor(13579.27283)) = '11010100001011', 'ok', 'nok');
select bin(round(43443, 2)), if(bin(round(43443, 2)) = '1010100110110011', 'ok', 'nok');
select bin(least(888, 3456, 22234)), if(bin(least(888, 3456, 22234)) = '1101111000', 'ok', 'nok');
select bin(power(7, 6)), if(bin(power(7, 6)) = '11100101110010001', 'ok', 'nok');
select bin(trunc(88820394029342+234923798293482093842038423, 0));

--TEST: expressions
select bin(12*976), if(bin(12*976) = '10110111000000', 'ok', 'nok');
select bin(bin(99999/34)), if(bin(bin(99999/34)) = '1011110001010000110001000011100111101', 'ok', 'nok');
select bin((12 or 456)), if(bin((12 or 456)) = '1', 'ok', 'nok');
select bin((392394234 and 392394234)), if(bin((392394234 and 392394234)) = '1', 'ok', 'nok');

