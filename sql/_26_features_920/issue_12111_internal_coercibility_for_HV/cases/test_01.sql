set names utf8;

prepare stmt from 'select COALESCE(?, ?)';
execute stmt using null, 'OK';
execute stmt using 'OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select DECODE(?, ?, ?, ?, ?, ?)';
execute stmt using 'A', 'a', 'NOK', 'A', 'OK', 'NOK';
execute stmt using 'A', 'A', 'OK', 'a', 'NOK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select GREATEST(?, ?, ?, ?, ?, ?)';
execute stmt using 'A', 'B', 'C', 'D', 'E', 'F-OK';
execute stmt using 'A', 'B', 'C', 'D', 'E', 'E-OK';
deallocate prepare stmt;

prepare stmt from 'select IF(?, ?, ?)';
execute stmt using '1', 'OK', 'NOK';
execute stmt using '0', 'NOK', 'OK';
deallocate prepare stmt;

prepare stmt from 'select IF(?=?, ?, ?)';
execute stmt using '1', '1', 'OK', 'NOK';
execute stmt using '0', '0', 'OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select IFNULL(?, ?)';
execute stmt using null, 'OK';
execute stmt using 'OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select NVL(?, ?)';
execute stmt using null, 'OK';
execute stmt using 'OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select DECODE(ISNULL(?), ?, ?, ?)';
execute stmt using null, 1, 'OK', 'NOK';
execute stmt using 'A', 0, 'OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select LEAST(?, ?, ?, ?, ?, ?)';
execute stmt using 'A-OK', 'B', 'C', 'D', 'E', 'F-NOK';
deallocate prepare stmt;

prepare stmt from 'select NULLIF(?, ?)';
execute stmt using 'A', 'A';
execute stmt using 1, 1;
execute stmt using 1, '1';
deallocate prepare stmt;

prepare stmt from 'select NULLIF(?, ?)';
execute stmt using 'A', 'A';
execute stmt using 1, 1;
execute stmt using 1, '1';
deallocate prepare stmt;

set names iso88591;
