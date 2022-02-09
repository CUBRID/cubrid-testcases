prepare stmt from 'select COALESCE(?, ?)';
set names iso88591;
execute stmt using null, 'OK';
execute stmt using 'OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select DECODE(?, ?, ?, ?, ?, ?)';
set names utf8 collate utf8_en_ci;
execute stmt using 'A', 'a', 'OK', 'A', 'NOK', 'NOK';
set names utf8 collate utf8_en_cs;
execute stmt using 'A', 'a', 'NOK', 'A', 'OK', 'NOK';
set names utf8;
execute stmt using 'A', 'a', 'NOK', 'A', 'OK', 'NOK';
set names iso88591 collate iso88591_en_ci;
execute stmt using 'A', 'a', 'OK', 'A', 'NOK', 'NOK';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', 'a', 'NOK', 'A', 'OK', 'NOK';
set names utf8 collate utf8_gen_ci;
execute stmt using 'A', 'a', 'OK', 'A', 'NOK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select DECODE(?, ?, ?, ?, ?, ?)';
SET NAMES utf8 COLLATE utf8_de_exp_ai_ci; 
execute stmt using  'ä', 'A E', 'NOK', 'Ä', 'OK', 'NOK';
execute stmt using  'äää', 'AE AE AE', 'NOK', 'ÄÄÄ', 'OK', 'NOK';
SET NAMES utf8 COLLATE utf8_es_cs; 
execute stmt using  'ñ','N', 'NOK','ñ','OK', 'NOK';
deallocate prepare stmt;

prepare stmt from 'select collation(?), collation(?)';
set names utf8 collate utf8_gen_ci;
execute stmt using 'A', 'a';
set names utf8 collate utf8_gen;
execute stmt using 'A', 'a';
deallocate prepare stmt;

--TODO
--prepare stmt from 'select GREATEST(?, ?, ?, ?, ?, ?)';
--set names utf8 collate utf8_en_cs;
--execute stmt using 'a', 'b', 'c', 'd', 'e-OK', 'F';
--set names utf8 collate utf8_en_ci;
--execute stmt using 'a', 'b', 'c', 'd', 'e', 'F-OK';
--deallocate prepare stmt;

set names iso88591;
prepare stmt from 'select IF(?<>0, ?, ?)';
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

