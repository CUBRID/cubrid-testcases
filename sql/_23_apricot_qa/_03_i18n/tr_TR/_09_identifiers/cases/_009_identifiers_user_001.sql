--+ holdcas on;
create user u_Çç_Ğğ_İı_Öö_Şş_Üü PASSWORD 'abc';
--test
CALL login ('u_Çç_Ğğ_İı_Öö_Şş_Üü', 'abc') ON CLASS db_user;
--test 
SELECT CURRENT_USER;
--test
CALL login ('dba', '') ON CLASS db_user;
--test
CALL drop_user ('u_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user;
--test 
SELECT CURRENT_USER;

--+ holdcas off;
