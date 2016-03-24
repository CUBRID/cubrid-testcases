--+ holdcas on;
set names utf8;
--test
select repeat('Ğülen',0);
--test
select repeat('Ğü',-1);
--test
select repeat('Ğu',32000000);
--test
select repeat('Ğu',16000000);
set names iso88591;
commit;
--+ holdcas off;

