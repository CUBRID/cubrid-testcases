--+ holdcas on;
set names utf8;

--test
SELECT ELT(3,'string1' collate utf8_ro_cs,'Bună', 'dimineața');
--test
SELECT ELT('2','Îți doresc','Mersi' collate utf8_ro_cs,' Mulţumesc');
 --test
SELECT ELT(-1, 'O', 'să', 'plouă?' collate utf8_ro_cs,'string2','string3');
--test
SELECT ELT(3, 'O', lower('să'), upper('plouă?' collate utf8_ro_cs),'string2','string3');
 
set names iso88591;
commit;
--+ holdcas off;
