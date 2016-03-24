--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_km_exp, a int);
-- UTF-8 test char is stored in 3 bytes
insert into t1 values (1, '២',1);
insert into t1 values (2, '២',1);
insert into t1 values (3, '២',1);
insert into t1 values (4, '២',1);
insert into t1 values (5, '២',1);
insert into t1 values (6, '២',1);

set system parameters 'group_concat_max_len=5';

select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

drop table t1;


-- fixed char
create table t1 (i1 int , s1 CHAR(2) collate utf8_km_exp, a int);
insert into t1 values (1, '២',1);
insert into t1 values (2, '២',1);
insert into t1 values (3, '២',1);
insert into t1 values (4, '២',1);
insert into t1 values (5, '២',1);
insert into t1 values (6, '២',1);

set system parameters 'group_concat_max_len=5';

select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=6';

select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;

