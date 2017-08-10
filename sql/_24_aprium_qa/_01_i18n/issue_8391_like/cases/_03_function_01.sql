set names utf8;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

drop table if exists t;
create table t(s char(10) collate utf8_gen_ci, p char(10) collate utf8_gen_ai_ci);
create index i on t(s);
insert into t values
('_bb','_B_%'),
('bb','B%_b'),
('bbb','%Bb_%'),
(NULL,'_bbb'),
('_bbb',NULL),
('ÄÄ','ä_');

select * from t where s like p collate utf8_gen_ci order by 1;
create view v1 as select s collate utf8_gen as s,p as p from t;
select * from v1 where s collate utf8_gen_ai_ci like p order by 1;
select * from v1 where s like p collate utf8_gen order by 1;

select * from v1 where upper(s) collate utf8_gen_ai_ci like lower(p) order by 1;
select * from v1 where upper(s) like p collate utf8_gen order by 1;
select * from t where trim(substr(s,2)) like p order by 1;

drop t;
drop v1;

create table t(s string collate utf8_gen,p string collate utf8_gen_ai_ci);
insert into t values('bbb','%Bb_%');
select * from t where upper(s) collate utf8_gen_ai_ci like lower(p) order by 1;
drop t;

create table t(s char(10) collate utf8_gen_ci,p char(10) collate utf8_gen_ai_ci);
insert into t values('bbb','%Bb_%');
select s,trim(replace(s,'b','B')),trim(p) from t where trim(replace(s,'b','B')) collate utf8_gen like trim(p) collate utf8_gen order by 1;

drop t;
set names iso88591;
