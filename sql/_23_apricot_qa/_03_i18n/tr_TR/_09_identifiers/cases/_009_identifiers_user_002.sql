--+ holdcas on;
create user u_Çç_Ğğ_İı_Öö_Şş_Üü PASSWORD 'abc';
create user u_Çç_Ğğ_İı_Öö_Şş_Üü1 PASSWORD 'abc';
--test 
SELECT  CURRENT_USER;
CALL login ('u_Çç_Ğğ_İı_Öö_Şş_Üü1', 'abc') ON CLASS db_user;
--test 
SELECT  CURRENT_USER;
--test
CALL login ('u_Çç_Ğğ_İı_Öö_Şş_Üü', 'u_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user;
--test 
SELECT  CURRENT_USER;
--test
CALL login ('dba', '') ON CLASS db_user;
--test 
SELECT  CURRENT_USER;
--test
ALTER USER u_Çç_Ğğ_İı_Öö_Şş_Üü PASSWORD 'u_Çç_Ğğ_İı_Öö_Şş_Üü';
--test
CALL login ('u_Çç_Ğğ_İı_Öö_Şş_Üü1', 'abc') ON CLASS db_user;
--test 
SELECT  CURRENT_USER;
--test
CALL login ('u_Çç_Ğğ_İı_Öö_Şş_Üü', 'u_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user;
--test 
SELECT  CURRENT_USER;
--test
CALL login ('dba', '') ON CLASS db_user;
--test
CALL drop_user ('u_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user;
--test
CALL drop_user ('u_Çç_Ğğ_İı_Öö_Şş_Üü1') ON CLASS db_user;
--test 
SELECT  CURRENT_USER;

--+ holdcas off;
