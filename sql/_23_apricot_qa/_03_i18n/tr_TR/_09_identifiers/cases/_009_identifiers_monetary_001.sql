CREATE TABLE Çç_Ğğ_İı_Öö_Şş_Üü (m1 monetary);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES ($1);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES ($-1);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\2);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\-2);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\TL3);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\TL-3);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\JPY4);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\JPY-4);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (￥-4);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (¥-4);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\RMB-4);
--test
INSERT INTO Çç_Ğğ_İı_Öö_Şş_Üü VALUES (\CNY-4);

-- default values
CREATE TABLE tÇç_Ğğ_İı_Öö_Şş_Üü (m1 monetary default \JPY1, m2 monetary default $-2, m3 monetary default \3, m4 monetary default \TL4,m5 monetary default ¥4);
--test
INSERT INTO tÇç_Ğğ_İı_Öö_Şş_Üü values(null,null,null,null,null);
--test
SELECT * FROM Çç_Ğğ_İı_Öö_Şş_Üü ORDER BY 1;
--test
desc tÇç_Ğğ_İı_Öö_Şş_Üü;
drop table Çç_Ğğ_İı_Öö_Şş_Üü;
drop table tÇç_Ğğ_İı_Öö_Şş_Üü;
