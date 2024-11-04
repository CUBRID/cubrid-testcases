--+ holdcas on;

--LIMIT opt_limit_expr 

drop table if exists t;
create table t ( i int , j varchar(10));
--insert 1000 rows.
prepare stmt from 'insert into t select * from (select rownum, substring(a.class_name,0,10) from _db_class a , _db_class b where a.class_name<>0 limit ?*?);';
execute stmt using 10,100 ;
deallocate prepare stmt;

--Statement 1
prepare stmt from 'delete from t  limit ?';
execute stmt using 1;
execute stmt using -4;
execute stmt using '1';
execute stmt using 'a';
deallocate prepare stmt;

--Statement 2
prepare stmt from 'delete from t  limit ?+?';
execute stmt using 1, 3;
execute stmt using 4, a;
execute stmt using 4, 'a';
deallocate prepare stmt;

--Statement 3
prepare stmt from 'delete from t  limit ?-?';
execute stmt using 8, 4;
deallocate prepare stmt;

--Statement 4
prepare stmt from 'delete from t  limit ?*?';
execute stmt using 2, 2;
deallocate prepare stmt;

--Statement 5
prepare stmt from 'delete from t  limit ?/?';
execute stmt using 12, 3;
deallocate prepare stmt;

--Statement 6
prepare stmt from 'delete from t  limit (?+?)+(?-?)';
execute stmt using 1, 3, 8, 4;
deallocate prepare stmt;

--Statement 7
prepare stmt from 'delete from t  limit (?+3)-(?-?)';
execute stmt using 1, 8, 4;
deallocate prepare stmt;

--Statement 8
prepare stmt from 'delete from t  limit 7-(3-?)*?+?';
execute stmt using 1, 2, 1;
deallocate prepare stmt;

--Statement 9
prepare stmt from 'delete from t  limit ?-(?-1)/?+5';
execute stmt using 1, 7, 3;
deallocate prepare stmt;

--Statement 10
prepare stmt from 'delete from t  limit ?/?';
execute stmt using 3, 2;
--Statement 11
execute stmt using 2, 3;
--Statement 12
execute stmt using 2, 0;
deallocate prepare stmt;

--Statement 14
prepare stmt from 'delete from t  limit -(?-?)/?+?';
execute stmt using 7, 1, 3, 5;
deallocate prepare stmt;

--Statement 16
prepare stmt from 'delete from t  limit (?-(?-?)/?+?)';
execute stmt using 0, 7, 1, 3, 5;
deallocate prepare stmt;

--Statement 17
prepare stmt from 'delete from t  limit 0-(?-?)/?+?';
execute stmt using 7, 1, 3, 5;
deallocate prepare stmt;

--Statement 18
prepare stmt from 'delete from t  limit ?*?-?*?/?';
execute stmt using 1, 2, 3, 4, 6;
SET @a=3;
execute stmt using @a, @a, @a, @a, @a;
deallocate prepare stmt;

--Statement 19
prepare stmt from 'delete from t  limit ?%?';
execute stmt using 12, 3;
deallocate prepare stmt;

autocommit off;
prepare stmt from 'delete from t  limit ?';
execute stmt using 2147483648;
rollback;
execute stmt using 9999999999999999999999999999999999999;
rollback;
deallocate prepare stmt;

SET @a=1024;
prepare stmt from 'delete from t  limit ?*?*?-1+?*?*?'; 
execute stmt using @a, @a, @a, @a, @a, @a;
rollback;
deallocate prepare stmt;
prepare stmt from 'delete from t  limit ?*?*?+?*?*?-1'; 
execute stmt using @a, @a, @a, @a, @a, @a;
rollback;
autocommit on;

DEALLOCATE PREPARE stmt;
DEALLOCATE VARIABLE @a ;
drop table if exists t;

--+ holdcas off;

