--test
CREATE TABLE t(col1 VARCHAR(1073741823) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(2049));
--test
CREATE TABLE t(col1 VARCHAR(1073741824) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(2048));
--test
CREATE TABLE t(col1 VARCHAR(1073741824) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(2049));
--test
CREATE TABLE t(col1 VARCHAR(1073741823) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(2048));
drop table t;
