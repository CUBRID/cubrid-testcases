--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_ro_cs, a int, b VARCHAR(20) collate utf8_ro_cs);
insert into t1 values (1, 'Îmi',1,'Ă');
insert into t1 values (2, 'Încântat',1,'ă');
insert into t1 values (3, 'cunoștință',2,'Î');
insert into t1 values (4, 'de',2,'î');
insert into t1 values (5, 'faceți?',2,'Șș');
insert into t1 values (6, 'Îți',2,'ȚȚ');
insert into t1 values (7, 'mulţ',3,'ââ');
insert into t1 values (8, 'râdeți',3,'ÂÂÂ');
insert into t1 values (9, 'întîlnim',3,'ââ');
insert into t1 values (10, 'Lăsa-mă',3,'ğü');
insert into t1 values (12, '你',3,'Ă');
insert into t1 values (11, null,3,null);

--test
select group_concat(s1 order by 1) from t1 group by a;
--test
select group_concat(s1 order by 1) from t1 group by b;
--test
select group_concat(s1 order by 1 separator 'b') from t1 group by a;
--test
select group_concat(s1 order by 1 separator '_好_') from t1 group by b;
--test
select group_concat(s1 order by 1 separator '____好好好好好____') from t1 group by b;
--test
set system parameters 'group_concat_max_len=30';
--test
select group_concat(s1 order by 1 separator '____好好好好____') from t1 group by a;
--test
set system parameters 'group_concat_max_len=30';
--test
select group_concat(s1 order by 1 separator '____好好好好____') from t1 group by b;
--test
set system parameters 'group_concat_max_len=1024';
select group_concat(s1 order by 1 separator '____好好好好____') from t1 group by a;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
