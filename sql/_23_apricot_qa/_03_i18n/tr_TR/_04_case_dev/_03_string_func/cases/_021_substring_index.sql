--+ holdcas on;
set names utf8;
select substring_index('Ğülen','le',1);

select substring_index('Ğülen','ül',1);

select substring_index('Ğülen','ül',2);

select substring_index('Ğülen','ü',-1);


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

select i1,s1, substring_index (s1, 'ü', 1) from t1 order by 1;

select i1,s1, substring_index (s1, 'kr', 1) from t1 order by 1;

select i1,s1, substring_index (s1, 'ü', -1) from t1 order by 1;

select i1,s1, substring_index (s1, 'Şü', -1) from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
