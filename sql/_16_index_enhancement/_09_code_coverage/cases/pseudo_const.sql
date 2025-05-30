create table t3 (id1 int, id2 varchar(30), id3 int);

insert into t3 values (5,'mnpqrt',55), 
(10,'abcd',100), 
( 11,'abmnp',111), 
( 15,'mnpde',111), 
( 5,'abcde',55), 
( 10,'abc',100), 
( 10,'abc',100), 
(11,'ab ',111), 
( 10,'abc',100), 
(10,'bcd',100), 
(11,'abxyz',111), 
(5,'amnpqrt',55), 
(12,'abmnp',122), 
(18,'mnpd ',181), 
(8,'abcd',88), 
(20,'mnp',200), 
(21,'mn ',211), 
(13,'abmnp',133);

select * from t3 where id1 in (1,2);
select * from t3 where id1 between 1 and 2;
prepare stmt from 'select * from t3 where id1 > unix_timestamp()-1;';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > -unix_timestamp();';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > mod(unix_timestamp(),2);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > ln (unix_timestamp());';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > round (unix_timestamp());';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > instr ( cast(unix_timestamp() as varchar), ''1'', 1);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > cast(substring(cast(unix_timestamp() as varchar)from 1) as int);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > char_length(space(unix_timestamp()/100000));';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > char_length(ltrim(space(unix_timestamp()/100000)));';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > char_length(lpad('''',unix_timestamp(),''''));';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > cast(add_months(date''10/10/10'',unix_timestamp()) as int);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > cast(sec_to_time(unix_timestamp()) as int);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > cast(timestamp(date''10/10/10'', unix_timestamp()) as int);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > atan2(unix_timestamp(),2);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > to_number(unix_timestamp());';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > if(true,unix_timestamp(),2);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > ifnull(unix_timestamp(),2);';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > char_length(concat(unix_timestamp(),''abc''));';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > char_length(concat_ws(''-'', unix_timestamp(),''abc''));';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > char_length(mid(concat_ws(''-'',unix_timestamp(),''abc''),2,3));';
deallocate prepare stmt;
prepare stmt from 'select * from t3 where id1 > greatest(unix_timestamp());';
deallocate prepare stmt;

drop table t3;
