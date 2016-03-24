--+ holdcas on;
set names utf8;
--test
select substring_index('Ğülen','le',0);
--test
select substring_index('Ğülen','ül',1.2);
--test
select substring_index('Ğülen','ül',100);
--test
select substring_index('Ğülen','b',-1);
--test
select substring_index('Ğülen',null,-1);
--test
select substring_index('Ğülen','',2);
set names iso88591;
commit;
--+ holdcas off;

