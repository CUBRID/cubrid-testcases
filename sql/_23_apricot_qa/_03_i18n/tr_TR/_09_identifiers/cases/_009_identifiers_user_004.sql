--test 
CALL add_user ('AB_Çç_Ğğ_İı_Öö_Şş_Üü', '') ON CLASS _db_user to user_common;
--test 
CALL set_password('P_Çç_Ğğ_İı_Öö_Şş_Üü') on user_common;
--test 
CALL find_user('AB_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS db_user to x;
--test 
SELECT x FROM db_root;
select name, id, password, direct_groups, groups, authorization, triggers, is_loginable, is_system_created, comment from _db_user where name =upper('AB_Çç_Ğğ_İı_Öö_Şş_Üü');
--test
CALL drop_user ('AB_Çç_Ğğ_İı_Öö_Şş_Üü') ON CLASS _db_user;
--test 
select name, id, password, direct_groups, groups, authorization, triggers, is_loginable, is_system_created, comment from _db_user where name =upper('AB_Çç_Ğğ_İı_Öö_Şş_Üü');
