--+ holdcas on;

--LIMIT opt_limit_expr1 , opt_limit_expr2 ; 

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 15 rows
prepare stmt from 'insert into t select rownum-2 , substring(class_name,0,10) from _db_class where class_name limit ?, ?*?*?*2-?/2'; 
SET @a=2;
execute stmt using @a, @a, @a, @a, @a;
select * from t order by 1;

--Statement 1
prepare stmt from 'select * from t order by 1, 2 limit ?,  ?+?';
execute stmt using '', '', '';
execute stmt using ' ', ' ', ' ';
execute stmt using 4,  1,  3  ;
execute stmt using -4,  1,  3  ;
execute stmt using '', 1,  3  ;
execute stmt using  4, ' ', 3;
execute stmt using  4, 1, '3';
execute stmt using  '4', '1', '0';

--Statement 2
prepare stmt from 'select * from t order by 1, 2 limit ?+?,  ?-?';
execute stmt using null, null, null, null;
execute stmt using 1, 3,  8, 4  ;

prepare stmt from 'select * from t order by 1, 2 limit ?*?,  ?-?';
execute stmt using null, null, null, null;
execute stmt using 1, 3,  8, 4  ;

--Statement 3
prepare stmt from 'select * from t order by 1, 2 limit ?-?,  ?*2'; 
execute stmt using null, null, null;
execute stmt using 8, 4, 2  ;

--Statement 4
prepare stmt from 'select * from t order by 1, 2 limit ?*2,  ?/?'; 
execute stmt using null, null, null;
execute stmt using 2, 12, 3 ;


--Statement 5
prepare stmt from 'select * from t order by 1, 2 limit ?/?,  (?+?)+(?-?)';
execute stmt using 12,3,  1,3,8,4;

--Statement 6
prepare stmt from 'select * from t order by 1, 2 limit  ?/?+?, ?-?'; 
execute stmt using  10,2,1, 5,1  ;

--Statement 7
prepare stmt from 'select * from t order by 1, 2 limit (?+?)-(?-4),  (1+?)+(?-4)';
execute stmt using 1,3,8,3,8 ;

--Statement 8
prepare stmt from 'select * from t order by 1, 2 limit (?+?)-(?-?),  ?-(?-?)*?+?';
execute stmt using 1,3,8,4,  7,3,1,2,1 ;

--Statement 9
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)*?+?,  1-(?-?)/?+?';
execute stmt using null, null, null, null, null, null, null, null, null;
execute stmt using 7,3,1,2,1,  7,1,3,5 ;

--Statement 10
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)/?+?,  ?/?';
execute stmt using 1,7,1,3,5,  3,2 ;

--Statement 11
prepare stmt from 'select * from t order by 1, 2 limit ?/2,  ?/3 ';
execute stmt using  3,  @a  ;

--Statement 12
prepare stmt from 'select * from t order by 1, 2 limit ?/?,  ?/?';
execute stmt using  2, 3,  2, 0;

--Statement 13
prepare stmt from 'select * from t order by 1, 2 limit ?/?,  ?';
execute stmt using 2, 0,  4 ;
execute stmt using 2, 1,  4 ;
execute stmt using 2, 1,  -4 ;

--Statement 14
prepare stmt from 'select * from t order by 1, 2 limit ?,  -(?-?)/?+?';
prepare stmt from 'select * from t order by 1, 2 limit ?,  (?-?)/?+?';
execute stmt using 4, 7, 1, 3, 5  ;

--Statement 15
prepare stmt from 'select * from t order by 1, 2 limit (?-?)/?+?,   ?-(?-?)/?';
execute stmt using -7,1,3,5,   0,7,1,3  ;
execute stmt using -7,1,4,5,   10,7,1,3  ;

--Statement 16
prepare stmt from 'select * from t order by 1, 2 limit ?-(?-?)/?,   ?';
execute stmt using 0,7,1,3,   4  ;
execute stmt using 10,7,1,3,   4  ;

--Statement 17
prepare stmt from 'select * from t order by 1, 2 limit ?,   ?';
execute stmt using -2,    4 ;
execute stmt using @a ,    @a  ;
execute stmt using b,    b  ;
execute stmt using 'c',    2  ;
execute stmt using @a,    2+b  ;
execute stmt using 1,    '2+c'  ;
execute stmt using 1+1,    2+@a  ;

SET @a=48;
SET @b=5;
SET @c=1;
prepare stmt from 'select * from t order by 1, 2 limit (?/?)+?, ?-?';
execute stmt using @a, @b, @c, @b, @c; 

prepare stmt from 'select * from t order by 1, 2 limit ?%?';
execute stmt using @a, @b;

SET @a=4;
SET @c=2;
--Statement 19
prepare stmt from 'select * from t order by 1, 2 limit ?, 1*?/3*?/?/1*?'; 
execute stmt using @c, @c, @a, @b, @c ;

prepare stmt from 'SELECT t1.* FROM (SELECT * FROM t AS t2 WHERE i > 5 order by 1 LIMIT ?+? ) AS t1 order by 1 LIMIT ?/?,?*?';
execute stmt using  2, 3, 5 , 4, 3 ,2 ;

DEALLOCATE PREPARE  stmt;
DEALLOCATE VARIABLE @a, @b, @c ;
drop table if exists t;

--+ holdcas off;

