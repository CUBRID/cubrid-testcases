
create table t1 (i integer);

create user u_Çç_Ğğ_İı_Öö_Şş_Üü;

create user g_Çç_Ğğ_İı_Öö_Şş_Üü members u_Çç_Ğğ_İı_Öö_Şş_Üü;

grant select on t1 to u_Çç_Ğğ_İı_Öö_Şş_Üü;

grant delete on t1 to g_Çç_Ğğ_İı_Öö_Şş_Üü;

show grants for u_Çç_Ğğ_İı_Öö_Şş_Üü;

show grants for g_Çç_Ğğ_İı_Öö_Şş_Üü;

drop user G_ÇÇ_ĞĞ_İı_ÖÖ_ŞŞ_ÜÜ;


drop user u_çç_ğğ_İı_öö_şş_üü;
drop user u_Çç_Ğğ_İı_Öö_Şş_Üü;
drop user g_Çç_Ğğ_İı_Öö_Şş_Üü;

drop table t1;

