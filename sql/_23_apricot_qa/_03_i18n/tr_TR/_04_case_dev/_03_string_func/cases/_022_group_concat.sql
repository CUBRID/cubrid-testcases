--+ holdcas on;
set names utf8;

create table t1 (i1 int , s1 VARCHAR(20)  collate utf8_tr_cs, a int, b VARCHAR(20)  collate utf8_tr_cs);
insert into t1 values (1, 'Ğülen',1,'ğü L');
insert into t1 values (2, 'Şükr',1,'üS');
insert into t1 values (3, 'Sınri',2,'İzğ');
insert into t1 values (4, 'Şükran',2,'üS');
insert into t1 values (5, 'SevINÇ',2,'ğü L');
insert into t1 values (6, 'süç',2,'üS');
insert into t1 values (7, 'İzğü',3,'İzğ');
insert into t1 values (8, 'Dön',3,'İzğ');
insert into t1 values (9, 'Ördü',3,'üS');
insert into t1 values (10, 'ükr',3,'ğü L');

select group_concat (s1 order by 1) from t1 group by a;

select group_concat (s1 order by 1) from t1 group by b;

select group_concat (s1 order by 1 separator '_ü_') from t1 group by a;

select group_concat (s1 order by 1 separator '_ü_') from t1 group by b;

select group_concat (s1 order by 1 separator '____üüüüü____') from t1 group by b;

set system parameters 'group_concat_max_len=65';

select group_concat (s1 order by 1 separator '____üüüüü____') from t1 group by b;

set system parameters 'group_concat_max_len=64';

select group_concat (s1 order by 1 separator '____üüüüü____') from t1 group by b;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
