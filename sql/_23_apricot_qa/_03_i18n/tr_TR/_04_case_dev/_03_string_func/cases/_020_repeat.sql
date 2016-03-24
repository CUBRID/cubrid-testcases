--+ holdcas on;
set names utf8;
select repeat('Ğülen',1);

select repeat('Ğü',2);

select repeat('Ğu',3);

create table t1 (i1 int , s1 VARCHAR(20)  collate utf8_tr_cs);
insert into t1 values (1, 'Ğülen');
insert into t1 values (2, 'Şükr');
insert into t1 values (3, 'Sınri');
insert into t1 values (4, 'Şükran');
insert into t1 values (5, 'SevINÇ');
insert into t1 values (6, 'süç');
insert into t1 values (7, 'İzğü');
insert into t1 values (8, 'Dön');
insert into t1 values (9, 'Ö');
insert into t1 values (10, 'ükr');

select i1,s1, repeat (s1, 1) from t1 order by 1;

select i1,s1, repeat (s1, 3) from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
