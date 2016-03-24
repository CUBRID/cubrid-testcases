--+ holdcas on;
set names utf8;
--test
select insert('Ğülen',0,1,'x');
--test
select insert('Ğülen',0,2,'İ');
--test
select insert('Ğülen',-1,1,'İzgğ');
--test
select insert('Ğülen',2,-1,'x');
--test
select insert('Ğülen',2,6,'İ');
--test
select insert('Ğülen',2,1,'İzgğ');
--test
select insert('Ğülen',2,7,'x');
--test
select insert('Ğülen',7,100,'İ');
--test
select insert('Ğülen',2,5,'');
--test
select insert('Ğülen',3,0,null);
--test
select insert('Ğülen',3,-1,null);
--test
select insert('',1,1,'İzgğ');

set names iso88591;
commit;
--+ holdcas off;
