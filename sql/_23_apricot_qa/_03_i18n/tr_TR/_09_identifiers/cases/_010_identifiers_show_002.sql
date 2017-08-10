--+ holdcas on;
set names utf8;
CREATE TABLE Çç_Ğğ_İı_Öö_Şş_Üü ( 
  Çç_Ğğ        char(10) collate binary    NOT NULL default'%你好', 
  İı_Öö_       VARCHAR(20) collate binary default'Ğğ',
  _Şş_Üü       string
  );
--test
 SHOW COLUMNS FROM Çç_Ğğ_İı_Öö_Şş_Üü;
 --test
 SHOW COLUMNS FROM Çç_Ğğ_İı_Öö_Şş_Üü LIKE '%ç%';
 --test
 SHOW COLUMNS FROM Çç_Ğğ_İı_Öö_Şş_Üü where "Default" like '_\%你%' escape '\';
 DESC Çç_Ğğ_İı_Öö_Şş_Üü;
 drop table Çç_Ğğ_İı_Öö_Şş_Üü;
 set names iso88591;
commit;
--+ holdcas off;
