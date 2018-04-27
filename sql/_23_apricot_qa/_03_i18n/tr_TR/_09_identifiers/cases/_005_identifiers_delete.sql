--+ holdcas on;
set names utf8;
--test table name
create table Çç_Ğğ_İı_Öö_Şş_Üü(s1 varchar(200) collate binary);
--test column
alter table Çç_Ğğ_İı_Öö_Şş_Üü add column i_Çç_Ğğ_İı_Öö_Şş_Üü int;
--test insert
insert into Çç_Ğğ_İı_Öö_Şş_Üü values('Çç_Ğğ_İı_Öö_Şş_Üü',1);
--test select
select * from Çç_Ğğ_İı_Öö_Şş_Üü;
--test select
select Çç_Ğğ_İı_Öö_Şş_Üü from Çç_Ğğ_İı_Öö_Şş_Üü;
--test trigger
create trigger tr_Çç_Ğğ_İı_Öö_Şş_Üü before insert on Çç_Ğğ_İı_Öö_Şş_Üü execute update Çç_Ğğ_İı_Öö_Şş_Üü set i_Çç_Ğğ_İı_Öö_Şş_Üü = 0;
--test insert
insert into Çç_Ğğ_İı_Öö_Şş_Üü values('Çç_Ğğ_İı_Öö_Şş_Üü',2);
--test select
select * from Çç_Ğğ_İı_Öö_Şş_Üü order by 2;
--test delete
delete from Çç_Ğğ_İı_Öö_Şş_Üü where i_Çç_Ğğ_İı_Öö_Şş_Üü=0;
--test select
select * from Çç_Ğğ_İı_Öö_Şş_Üü;
--test 
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;


