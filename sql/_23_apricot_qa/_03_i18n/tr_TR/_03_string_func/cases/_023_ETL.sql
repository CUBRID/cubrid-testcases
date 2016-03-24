--+ holdcas on;
set names utf8;
--test
SELECT ELT(3,'string1','string2','string3');
 --test
SELECT ELT('3','1/1/1','23:00:00','2001-03-04');
 --test
SELECT ELT(-1, 'string1','string2','string3');
--test
SELECT ELT(4,'string1','string2','string3');
--test
SELECT ELT(3.2,'string1','string2','string3');
--test
SELECT ELT('a','string1','string2','string3');
 
set names iso88591;
commit;
--+ holdcas off;
