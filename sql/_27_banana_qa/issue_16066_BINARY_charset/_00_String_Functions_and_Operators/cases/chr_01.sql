--+ holdcas on;
set names binary;
select chr(61);
select chr(61 using utf8);

set names utf8 collate utf8_en_cs;  
select chr(61 using binary);
select coercibility(chr(61 using binary));

set names iso88591;
commit;
--+ holdcas off;