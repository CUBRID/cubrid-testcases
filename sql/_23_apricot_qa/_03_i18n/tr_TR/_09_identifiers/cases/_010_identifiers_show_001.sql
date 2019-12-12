--+ holdcas on;
set names utf8;
CREATE TABLE Çç_Ğğ_İı_Öö_Şş_Üü(col INT NOT NULL AUTO_INCREMENT);
CREATE TABLE Sevinç(col INT NOT NULL AUTO_INCREMENT);
CREATE TABLE _Şükran(col INT NOT NULL AUTO_INCREMENT);
CREATE TABLE  İlhan(col INT NOT NULL AUTO_INCREMENT);
--test
SHOW FULL TABLES LIKE '%Çç%';
--test
SHOW FULL TABLES LIKE '%Şü%';
--test
SHOW FULL TABLES LIKE '%İ%';
--test
SHOW FULL TABLES LIKE '_İ%';
--test
SHOW  TABLES LIKE '_İ%';
--test
SHOW  TABLES LIKE '%Sev_n_' ;
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
drop table Sevinç;
drop table _Şükran;
drop table İlhan;
set names iso88591;
commit;
--+ holdcas off;