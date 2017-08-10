--+ holdcas on;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

set names utf8;
drop table if exists t;
create table t (i int, s char(10) collate utf8_de_exp_ai_ci,index i(s));

insert into t values (1,'Aexx');
insert into t values (2,'AExx');
insert into t values (3,'Äxxx');
insert into t values (4,'ä');

insert into t values (10,'oE');
insert into t values (11,'OE');
insert into t values (12,'ö');
insert into t values (13,'Ö');

insert into t values (21,'xxUex');
insert into t values (22,'xxUEx');
insert into t values (23,'xxüxx');
insert into t values (24,'xÜx');

insert into t values (31,'xxßxx');
insert into t values (32,'xxSSx');
insert into t values (32,'xssxx');

select * from t where s like 'ae%' order by 1;
select * from t where s like 'ä_%' order by 1;

select * from t where s like 'Oe%' order by 1;
select * from t where s like 'Ö%' order by 1;

select * from t where s like '%ue%' order by 1;
select * from t where s like '_%uE%' order by 1;
select * from t where s like '__ü%' order by 1;
select * from t where s like '_ü%' order by 1;
select * from t where s like '%ua%' order by 1;

select * from t where s like '_ß%' order by 1;
select * from t where s like '_%ß%' order by 1;
select * from t where s like '%ßx_' order by 1;
select * from t where s like '_%sS_%' order by 1;

drop table t;
set names iso88591;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

commit;
--+ holdcas off;
