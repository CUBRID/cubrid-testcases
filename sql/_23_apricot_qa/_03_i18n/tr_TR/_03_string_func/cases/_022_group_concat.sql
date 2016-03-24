--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_tr_cs_uca, a int, b VARCHAR(20) collate utf8_tr_cs_uca);
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
insert into t1 values (12, '你',3,'我');
insert into t1 values (11, null,3,null);

--test
select group_concat (s1 order by 1) from t1 group by a;
--test
select group_concat (s1 order by 1) from t1 group by b;
--test
select group_concat (s1 order by 1 separator '好') from t1 group by a;
--test
select group_concat (s1 order by 1 separator '_好_') from t1 group by b;
--test
select group_concat (s1 order by 1 separator '____好好好好好____') from t1 group by b;
--test
set system parameters 'group_concat_max_len=65';
--test
select group_concat (s1 order by 1 separator '____好好好好____') from t1 group by b;
--test
set system parameters 'group_concat_max_len=64';
--test
select group_concat (s1 order by 1 separator '____好好好好____') from t1 group by b;
--test
set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
