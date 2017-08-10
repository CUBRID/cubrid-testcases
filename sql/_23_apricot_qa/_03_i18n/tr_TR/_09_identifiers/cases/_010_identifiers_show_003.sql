--+ holdcas on;
set names utf8;
CREATE TABLE Çç_Ğğ_İı_Öö_Şş_Üü ( 
  Çç_Ğğ        char(10)    NOT NULL default'%你好', 
  İı_Öö_       VARCHAR(20) default'Ğğ',
  _Şş_Üü       string UNIQUE
  );
 create index i_Çç_Ğğ on Çç_Ğğ_İı_Öö_Şş_Üü(Çç_Ğğ  desc) where Çç_Ğğ like '\%你%' escape '\';
 create index i_İı_Öö_ on Çç_Ğğ_İı_Öö_Şş_Üü(trim(İı_Öö_));
 create UNIQUE index i_Şş_Üü  on Çç_Ğğ_İı_Öö_Şş_Üü(_Şş_Üü);
 create reverse index i_İı_Öö on Çç_Ğğ_İı_Öö_Şş_Üü(İı_Öö_);
 create reverse UNIQUE  index i_Çç_Ğğ_İı_Öö_Şş_Üü on Çç_Ğğ_İı_Öö_Şş_Üü(Çç_Ğğ,İı_Öö_,_Şş_Üü);
--test
SHOW INDEX IN Çç_Ğğ_İı_Öö_Şş_Üü;
 --test
SHOW INDEXES FROM Çç_Ğğ_İı_Öö_Şş_Üü;
 --test
SHOW INDEXES FROM Çç_Ğğ_İı_Öö_Şş_Üü;

drop table Çç_Ğğ_İı_Öö_Şş_Üü;
set names iso88591;
commit;
--+ holdcas off;
