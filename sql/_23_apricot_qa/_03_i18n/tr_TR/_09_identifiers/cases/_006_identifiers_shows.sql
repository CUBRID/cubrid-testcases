--+ holdcas on;
set names utf8;
--test table name
create table Çç_Ğğ_İı_Öö_Şş_Üü(s1 varchar(200));
--test column
alter table Çç_Ğğ_İı_Öö_Şş_Üü add column i_Çç_Ğğ_İı_Öö_Şş_Üü int;
--test constraint
alter table Çç_Ğğ_İı_Öö_Şş_Üü add constraint i_Çç_Ğğ_İı_Öö_Şş_Üü_i_u unique index (i_Çç_Ğğ_İı_Öö_Şş_Üü);
--test desc
desc Çç_Ğğ_İı_Öö_Şş_Üü;
--test desc index
show index in Çç_Ğğ_İı_Öö_Şş_Üü;
--test 
alter table Çç_Ğğ_İı_Öö_Şş_Üü drop constraint i_Çç_Ğğ_İı_Öö_Şş_Üü_i_u;
--test 
alter table Çç_Ğğ_İı_Öö_Şş_Üü drop column i_Çç_Ğğ_İı_Öö_Şş_Üü;
--test 
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;

