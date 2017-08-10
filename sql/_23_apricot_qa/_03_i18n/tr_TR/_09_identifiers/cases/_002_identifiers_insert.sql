--+ holdcas on;
set names utf8;
--test table name
create table Çç_Ğğ_İı_Öö_Şş_Üü(s1 varchar(200));
--test column
alter table Çç_Ğğ_İı_Öö_Şş_Üü add column i_Çç_Ğğ_İı_Öö_Şş_Üü int;
--test insert
insert into Çç_Ğğ_İı_Öö_Şş_Üü values('Çç_Ğğ_İı_Öö_Şş_Üü',1);
--test 
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;

