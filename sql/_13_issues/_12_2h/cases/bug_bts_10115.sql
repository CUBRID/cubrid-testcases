set names utf8;
drop table if exists t;

create table t(i int, s string, e enum('ß','SS','ss')) collate utf8_de_exp;
insert into t values(1,'SS',2),(2,'ss',3),(3,'ß',1);
select * from t order by 3;
alter table t collate utf8_de_exp_ai_ci;
alter table t change column e e enum('ß','SS','ss');
alter table t add column e2 enum('ß','SS','ss');
alter table t add column e2 enum('ß','ss');
alter table t add column e2 enum('ß','SS') collate utf8_de_exp;
update t set e2=s;
delete from t where i=2;
update t set e2=s;
drop t;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';
set names utf8;
create table t(i int, s string ,e enum('Ä','Ä')) collate utf8_de_exp;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';
alter table t change column s s enum('Ä','Ä');
drop t;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

create table t(i int,e enum('AE','Ä','ä')) collate utf8_de_exp_ai_ci;
create table t(i int,e enum('AE','Ä','ä')) collate utf8_de_exp;
drop t;
create table t(i int,e enum('ä','à','AE','ae')) collate utf8_fr_exp_ab;
drop t;

create table t(i int, s string,e enum('a','A')) collate utf8_en_ci;
show full columns from t;

create table t(i int, s string,e enum('a','A')) collate utf8_en_cs;
alter table t collate utf8_en_ci;
alter table t add column s2 string;
show full columns from t;

alter table t add column e1 enum('a', 'A');
alter table t change column e e enum('b', 'B');

drop t;

set names iso88591;

