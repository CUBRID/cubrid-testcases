--+ holdcas on;
set names utf8;
--test table name
create table Çç_Ğğ_İı_Öö_Şş_Üü(Çç INTEGER,Ğğ INTEGER not null,İı INTEGER unique,Öö VARCHAR(10),Şş VARCHAR(10),Üü VARCHAR(10) UNIQUE);
--test 
CREATE INDEX i_Çç_Ğğ_İı_Öö_Şş_Üü_Çç ON Çç_Ğğ_İı_Öö_Şş_Üü(Çç DESC);
--test 
CREATE INDEX i_Çç_Ğğ_İı_Öö_Şş_Üü_Öö ON Çç_Ğğ_İı_Öö_Şş_Üü(Öö(7));
--test 
CREATE INDEX i_Çç_Ğğ_İı_Öö_Şş_Üü_Çç_Öö on Çç_Ğğ_İı_Öö_Şş_Üü(Çç,Öö);
--test
CREATE UNIQUE INDEX i_Çç_Ğğ_İı_Öö_Şş_Üü_Ğğ_Şş ON Çç_Ğğ_İı_Öö_Şş_Üü(Ğğ,Şş);

--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (1,1,1,'Çç_Ğğ_İı','Çç_Ğğ_İı','Çç_Ğğ_İı');
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (2,2,2,'Öö_Şş_Üü','Öö_Şş_Üü','Öö_Şş_Üü');
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (2,3,3,'+Çç_Ğğ_İı','+Çç_Ğğ_İı','+Çç_Ğğ_İı');


--test
show index in Çç_Ğğ_İı_Öö_Şş_Üü;

--test
SELECT INDEX_CARDINALITY('dba.Çç_Ğğ_İı_Öö_Şş_Üü','i_Çç_Ğğ_İı_Öö_Şş_Üü_Çç_Öö',0);
--test
SELECT INDEX_CARDINALITY('dba.Çç_Ğğ_İı_Öö_Şş_Üü','i_Çç_Ğğ_İı_Öö_Şş_Üü_Çç_Öö',1);
--test
SELECT INDEX_CARDINALITY('dba.Çç_Ğğ_İı_Öö_Şş_Üü','i_Çç_Ğğ_İı_Öö_Şş_Üü_Çç_Öö',2);
--test
SELECT INDEX_CARDINALITY('dba.Çç_Ğğ_İı_Öö_Şş_Üü23','i_Çç_Ğğ_İı_Öö_Şş_Üü_Çç_Öö',1);
--test 
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;

