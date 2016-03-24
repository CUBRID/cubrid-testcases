--+ holdcas on;
set names utf8;
select insert('Ğülen',1,1,'x');

select insert('Ğülen',1,1,'İ');

select insert('Ğülen',1,1,'İzgğ');

select insert('Ğülen',2,1,'x');

select insert('Ğülen',2,1,'İ');

select insert('Ğülen',2,1,'İzgğ');

select insert('Ğülen',2,5,'x');

select insert('Ğülen',2,5,'İ');

select insert('Ğülen',2,5,'İzgğ');

select insert('Ğülen',3,0,'İ');

select insert('Ğülen',3,-1,'İ');

select insert('',1,1,'İzgğ');

create table t1 (i1 int , s1 VARCHAR(20)  collate utf8_tr_cs);
insert into t1 values (1, 'Ğülen');
insert into t1 values (2, 'Şükran');
insert into t1 values (3, 'Sınri');
insert into t1 values (4, 'Şükr');
insert into t1 values (5, 'SevINÇ');
insert into t1 values (6, 'süç');
insert into t1 values (7, 'İzğü');
insert into t1 values (8, 'Dön');
insert into t1 values (9, 'DÖn');
insert into t1 values (10, 'ükr');


select i1, s1, insert (s1,1,1,'I') from t1 order by 1;

select i1, s1, insert (s1,3,0,'ÇI_') from t1 order by 1;

select i1, s1, insert (s1,2,2,'CIŞ') from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
