--+ holdcas on;
set system parameters 'compat_mode=mysql';
SELECT '1', SUBSTRING('Quadratically',5) FROM db_root;
SELECT '2 CUBRID OK', SUBSTRING('foobarbar' FROM 4) FROM db_root;
SELECT '3', SUBSTRING('Quadratically',5,6) FROM db_root;
SELECT '4', SUBSTRING('Sakila', -3) FROM db_root;
SELECT '5', SUBSTRING('Sakila', -5, 3) FROM db_root;
SELECT '5', SUBSTRING(12343, 1, 3) FROM db_root;
SELECT '5', SUBSTRING(NULL, 2, 3) FROM db_root;
SELECT '5', SUBSTRING('foo', NULL, 3) FROM db_root;
SELECT '5', SUBSTRING('foo', 2, NULL) FROM db_root;
SELECT '6 CUBRID OK', SUBSTRING('Sakila' FROM -4 FOR 2) FROM db_root;

select substring('iweceuwirncueiwrnceuirncue',3,12378461287871233) from db_root;
select substring('iweceuwirncueiwrnceuirncue',1237846128787123,4) from db_root;
select substring('iweceuwirncueiwrnceuirncue',1237846128787123,12378461287871233) from db_root;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
