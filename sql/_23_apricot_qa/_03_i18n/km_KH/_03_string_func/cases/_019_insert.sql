--+ holdcas on;
set names utf8;
select insert('សុមករា',1,1,'១');

select insert('សុមករា',1,1,'អ');

select insert('សុមករា',1,1,'២');

select insert('សុមករា',2,1,'១');

select insert('សុមករា',2,1,'អ');

select insert('សុមករា',2,1,'២');

select insert('សុមករា',2,5,'១');

select insert('សុមករា',2,5,'អ');

select insert('សុមករា',2,5,'២');

select insert('សុមករា',3,0,'អ');

select insert('សុមករា',3,-1,'អ');

select insert('',1,1,'២');

create table t1 (i1 int , s1 VARCHAR(20) collate utf8_km_exp);
insert into t1 values (1, 'សុមករា');
insert into t1 values (2, 'ច');
insert into t1 values (3, 'ឧសភា');
insert into t1 values (4, 'មិនាសមេសា');
insert into t1 values (5, '៥ពុ');
insert into t1 values (6, '៧មិនា');
insert into t1 values (7, 'វិច្ឆិកាធ្នូ');
insert into t1 values (8, 'សុ');
insert into t1 values (9, 'សុ');
insert into t1 values (10, 'ឧសភា');


select i1, s1, insert (s1,1,1,'អ') from t1 order by 1;

select i1, s1, insert (s1,3,0,'អា_') from t1 order by 1;

select i1, s1, insert (s1,2,2,'ព្រ៨') from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;