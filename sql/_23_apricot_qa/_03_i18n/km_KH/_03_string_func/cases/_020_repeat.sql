--+ holdcas on;
set names utf8;
select repeat('សុមករា',1);

select repeat('១២',2);

select repeat('១០',3);

create table t1 (i1 int , s1 VARCHAR(20) collate utf8_km_exp);
insert into t1 values (1, 'សុមករា');
insert into t1 values (2, 'មិនាសមេសា');
insert into t1 values (3, 'ឧសភា');
insert into t1 values (4, 'ច');
insert into t1 values (5, '៥ពុ');
insert into t1 values (6, '៧មិនា');
insert into t1 values (7, 'វិច្ឆិកាធ្នូ');
insert into t1 values (8, 'សុ');
insert into t1 values (9, 'សុ');
insert into t1 values (10, 'ឧសភា');

select i1,s1, repeat (s1, 1) from t1 order by 1;

select i1,s1, repeat (s1, 3) from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;