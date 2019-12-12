--+ holdcas on;
set names utf8;
--test table name
create table Çç_Ğğ_İı_Öö_Şş_Üü(Öö VARCHAR(30) collate binary DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü');

--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES ('Çç_Ğğ_İı');
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES ('Öö_Şş_Üü');
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (null);

--test
SELECT Öö, DEFAULT(Öö) FROM Çç_Ğğ_İı_Öö_Şş_Üü order by 1, 2;

--test 
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;


