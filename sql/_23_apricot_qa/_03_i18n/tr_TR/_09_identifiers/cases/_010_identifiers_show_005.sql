--+ holdcas on;
set names utf8;
CREATE TABLE Çç_Ğğ_İı_Öö_Şş_Üü ( 
  Çç_Ğğ        char(10)    NOT NULL default'%你好', 
  İı_Öö_       VARCHAR(20) default'Ğğ',
  _Şş_Üü       string UNIQUE
  );
CREATE VIEW 视图 as Select * from Çç_Ğğ_İı_Öö_Şş_Üü where _Şş_Üü is not null with check option;

--test
SHOW CREATE VIEW "视图";
CREATE OR REPLACE VIEW 视图 as Select * from Çç_Ğğ_İı_Öö_Şş_Üü ORDER BY  Çç_Ğğ DESC;
--test
SHOW CREATE VIEW "视图";
drop view 视图;
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;

