--+ holdcas on;

--LIMIT opt_limit_expr1 OFFSET opt_limit_expr2 ;

drop table if exists t;
create table t ( i int , j varchar(10));
prepare stmt from 'insert into t select rownum-2, class_name from _db_class where length(class_name)<=10 limit ?*?*?*?-?/? OFFSET ?';     
execute stmt using   2 , 2 , 2 , 2 , 2 , 2 , 2;
select * from t order by 1;

--Statement 1 
prepare stmt from 'select * from t order by 1, 2 limit ?  OFFSET  -(?-?)/?+?';
prepare stmt from 'select * from t order by 1, 2 limit ?  OFFSET  (?-?)/?+?';
execute stmt using  4 , 7 , 1 , 3 , 5;

--Statement 2
prepare stmt from 'select * from t order by 1, 2 limit ?+?  OFFSET  ?-(?-?)/?';
execute stmt using  1 , 3 , 0 , 7 , 1 , 3;
execute stmt using  10 , 3 , 0 , 7 , 1 , 3;

--Statement 3
prepare stmt from 'select * from t order by 1, 2 limit ?+?  OFFSET  -?';
prepare stmt from 'select * from t order by 1, 2 limit ?+?  OFFSET  ?';
execute stmt using  1 , 3 , 2;
execute stmt using  1 , 3 , -2;

--Statement 4
prepare stmt from 'select * from t order by 1, 2 limit ?-?  OFFSET  ?';
execute stmt using  8 , 4 , 4;

--Statement 5
prepare stmt from 'select * from t order by 1, 2 limit ?*?  OFFSET  ?+?';
execute stmt using  2 , 2 , 1 , 3;

--Statement 6
prepare stmt from 'select * from t order by 1, 2 limit ?/?  OFFSET  ?-?';
execute stmt using  12 , 3 , 8 , 4;

--Statement 7
prepare stmt from 'select * from t order by 1, 2 limit (?+?)+(?-?)   OFFSET  ?*?';
execute stmt using 1 , 3 , 8 , 4 , 2 , 2;

--Statement 8
prepare stmt from 'select * from t order by 1, 2 limit (?+?)-(?-?)  OFFSET  ?/?';
execute stmt using 1 , 3 , 8 , 4 , 12 , 3;

--Statement 9
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)*?+?  OFFSET  (?+?)+(?-?)';
execute stmt using  7 , 3 , 1 , 2 , 1 , 1 , 3 , 8 , 4;

--Statement 10
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)/?+?  OFFSET  (?+?)-(?-?)';
execute stmt using  1 , 7 , 1 , 3 , 5 , 1 , 3 , 8 , 4;

--Statement 11
prepare stmt from 'select * from t order by 1, 2 limit ?/?   OFFSET  ?-(?-?)*?+?';
execute stmt using  3 , 2 , 7 , 3 , 1 , 2 , 1;

--Statement 12
prepare stmt from 'select * from t order by 1, 2 limit ?/?   OFFSET  ?-(?-?)/?+?';
execute stmt using  2 , 3 , 1 , 7 , 1 , 3 , 5;

--Statement 13
prepare stmt from 'select * from t order by 1, 2 limit ?/?   OFFSET  ?/?';
execute stmt using  2 , 0 , 3 , 2;
execute stmt using  2 , 1 , 3 , 2;
set @a=2;
execute stmt using @a, 1 , 3 , @a;

--Statement 14
prepare stmt from 'select * from t order by 1, 2 limit -?   OFFSET  ?/?'; 
prepare stmt from 'select * from t order by 1, 2 limit ?   OFFSET  ?/?'; 
execute stmt using 4 , 2 , 3; 

--Statement 15
prepare stmt from 'select * from t order by 1, 2 limit -(?-?)/?+?   OFFSET   ?/?';
prepare stmt from 'select * from t order by 1, 2 limit (?-?)/?+?   OFFSET   ?/?';
execute stmt using 7 , 1 , 3 , 5 , 2 , 0;
execute stmt using 7 , 1 , 3 , 5 , 2 , 1;

--Statement 16
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)/?   OFFSET  -?'; 
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)/?   OFFSET  ?'; 
execute stmt using  0 , 7 , 1 , 3 , 4; 
execute stmt using  10 , 7 , 1 , 3 , 4; 

DEALLOCATE PREPARE  stmt;
DEALLOCATE VARIABLE @a ;
drop table if exists t;

--+ holdcas off;

