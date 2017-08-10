--+ holdcas on;
set names utf8;
CREATE TABLE Çç_Ğğ_İı_Öö_Şş_Üü ( 
  Çç_Ğğ        char(10)    NOT NULL default'%你好', 
  İı_Öö_       VARCHAR(20) default'Ğğ',
  _Şş_Üü       string UNIQUE
  );
CREATE TABLE 表1 ( 
  Çç_Ğğ        char(10)    NOT NULL default'%你好', 
  İı_Öö_       VARCHAR(20) default'Ğğ',
  _Şş_Üü       string UNIQUE
  );
create user Çç_Ğğ_İı;
create user 你好;
GRANT INSERT,SELECT,UPDATE,DELETE ON Çç_Ğğ_İı_Öö_Şş_Üü TO Çç_Ğğ_İı,你好;
GRANT INSERT,SELECT ON 表1 to Çç_Ğğ_İı;
GRANT SELECT ON 表1 to 你好;
--test
SHOW GRANTS FOR Çç_Ğğ_İı;
--test
SHOW GRANTS FOR 你好;
--test
REVOKE SELECT ON Çç_Ğğ_İı_Öö_Şş_Üü,表1 from Çç_Ğğ_İı,你好;
--test
SHOW GRANTS FOR Çç_Ğğ_İı;
--test
SHOW GRANTS FOR 你好;

drop user Çç_Ğğ_İı;
drop user 你好;
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
drop table 表1;
set names iso88591;
commit;
--+ holdcas off;
