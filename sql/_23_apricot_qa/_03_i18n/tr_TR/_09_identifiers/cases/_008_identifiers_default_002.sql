--test
CREATE TABLE t(col1 VARCHAR(1073741823) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(1073741824));
--test
CREATE TABLE t(col1 VARCHAR(1073741824) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(1073741823));
--test
CREATE TABLE t(col1 VARCHAR(1073741824) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(1073741824));
--test
CREATE TABLE t(col1 VARCHAR(1073741823) DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(1073741823));
drop table t;