--test 
CALL add_user ('AB_Çç_Ğğ_İı_Öö_Şş_Üü', '') ON CLASS db_user to user_common;
--test 
CALL set_password('P_Çç_Ğğ_İı_Öö_Şş_Üü') on user_common;
--test 
CALL find_user('AB_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user to x;
--test 
SELECT x FROM db_root;
SELECT * from db_user where name =upper('AB_Çç_Ğğ_İı_Öö_Şş_Üü');
--test
CALL drop_user ('AB_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user;
--test 
SELECT * from db_user where name =upper('AB_Çç_Ğğ_İı_Öö_Şş_Üü');
