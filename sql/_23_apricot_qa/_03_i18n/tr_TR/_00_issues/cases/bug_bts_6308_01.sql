CALL add_user ('你好_Çç_Ğğ_İı_Öö_Şş_Üü', '') ON CLASS _db_user to user_common;
CALL add_user ('你好', '') ON CLASS _db_user to user_common;
CALL set_password('你好_Çç_Ğğ_İı_Öö_Şş_Üü') on user_common;
CALL set_password('你好') on user_common;
CALL find_user('你好') ON CLASS db_user to x;
SELECT x FROM db_root;
CALL drop_user ('你好') ON CLASS _db_user;
SELECT name, id, password, direct_groups, groups, authorization, triggers, is_loginable, is_system_created, comment from _db_user where name ='你好';
