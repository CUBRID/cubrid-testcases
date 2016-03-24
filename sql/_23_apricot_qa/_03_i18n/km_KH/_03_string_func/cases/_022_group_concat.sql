--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_km_exp, a int, b VARCHAR(20) collate utf8_km_exp);
insert into t1 values (1, 'សុមករា',1,'សុ កុ');
insert into t1 values (2, 'មិនាសមេសា',1,'កុេ');
insert into t1 values (3, 'ឧសភា',2,'មិថុនា');
insert into t1 values (4, 'ច',2,'អ៧');
insert into t1 values (5, '៥ពុ',2,'សុ កុ');
insert into t1 values (6, '៧មិនា',2,'អ៧');
insert into t1 values (7, 'វិច្ឆិកាធ្នូ',3,'មិថុនា');
insert into t1 values (8, 'សុ',3,'មិថុនា');
insert into t1 values (9, 'សុ',3,'អ៧');
insert into t1 values (10, 'ឧសភា',3,'សុ កុ');

select group_concat (s1 order by 1) from t1 group by a;

select group_concat (s1 order by 1) from t1 group by b;

select group_concat (s1 order by 1 separator '_ស_') from t1 group by a;

select group_concat (s1 order by 1 separator '_ស_') from t1 group by b;

select group_concat (s1 order by 1 separator '____សសសសស____') from t1 group by b;

set system parameters 'group_concat_max_len=65';

select group_concat (s1 order by 1 separator '____សសសសស____') from t1 group by b;

set system parameters 'group_concat_max_len=64';

select group_concat (s1 order by 1 separator '____សសសសស____') from t1 group by b;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;