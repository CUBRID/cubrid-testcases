--+ holdcas on;

--LIMIT opt_limit_expr 

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 15 rows. 
prepare stmt from 'insert into t select rownum, substring(class_name,0,10) from _db_class where class_name limit ?*?+?*?-?/?+5; ';
execute stmt using 1, 7, 2, 2, 2,2 ;
select * from t order by 1;

--Statement 1
prepare stmt from 'select * from t order by 1, 2 limit ?';
execute stmt using 1;
execute stmt using -4;
execute stmt using '1';
execute stmt using 'a';

--Statement 2
prepare stmt from 'select * from t order by 1, 2 limit ?+?';
execute stmt using 1, 3;
execute stmt using 4, a;
execute stmt using 4, 'a';

--Statement 3
prepare stmt from 'select * from t order by 1, 2 limit ?-?';
execute stmt using 8, 4;

--Statement 4
prepare stmt from 'select * from t order by 1, 2 limit ?*?';
execute stmt using 2, 2;

--Statement 5
prepare stmt from 'select * from t order by 1, 2 limit ?/?';
execute stmt using 12, 3;

--Statement 6
prepare stmt from 'select * from t order by 1, 2 limit (?+?)+(?-?)';
execute stmt using 1, 3, 8, 4;

--Statement 7
prepare stmt from 'select * from t order by 1, 2 limit (?+3)-(?-?)';
execute stmt using 1, 8, 4;

--Statement 8
prepare stmt from 'select * from t order by 1, 2 limit 7-(3-?)*?+?';
execute stmt using 1, 2, 1;

--Statement 9
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-1)/?+5';
execute stmt using 1, 7, 3;

--Statement 10
prepare stmt from 'select * from t order by 1, 2 limit ?/?';
execute stmt using 3, 2;
--Statement 11
execute stmt using 2, 3;
--Statement 12
execute stmt using 2, 0;

--Statement 14
prepare stmt from 'select * from t order by 1, 2 limit -(?-?)/?+?';
execute stmt using 7, 1, 3, 5;

--Statement 16
prepare stmt from 'select * from t order by 1, 2 limit (?-(?-?)/?+?)';
execute stmt using 0, 7, 1, 3, 5;

--Statement 17
prepare stmt from 'select * from t order by 1, 2 limit 0-(?-?)/?+?';
execute stmt using 7, 1, 3, 5;

--Statement 18
prepare stmt from 'select * from t order by 1, 2 limit ?*?-?*?/?';
execute stmt using 1, 2, 3, 4, 6;
SET @a=3;
execute stmt using @a, @a, @a, @a, @a;

--Statement 19
prepare stmt from 'select * from t order by 1, 2 limit ?%?';
execute stmt using 12, 3;


prepare stmt from 'select * from t order by 1, 2 limit ?';
execute stmt using 2147483648;
execute stmt using 9999999999999999999999999999999999999;

SET @a=1024;
prepare stmt from 'select * from t order by 1, 2 limit ?*?*?-1+?*?*?'; 
execute stmt using @a, @a, @a, @a, @a, @a;
prepare stmt from 'select * from t order by 1, 2 limit ?*?*?+?*?*?-1'; 
execute stmt using @a, @a, @a, @a, @a, @a;


DEALLOCATE PREPARE  stmt;
DEALLOCATE VARIABLE @a ;
drop table if exists t;

--+ holdcas off;

