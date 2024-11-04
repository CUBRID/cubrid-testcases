--+ holdcas on;

set names utf8;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

drop table if exists t;

create table t(s string collate utf8_gen_ci);
create index i on t(right(s,2));
insert into t values
('_bb'),
('bb'),
('bbb'),
(NULL),
('_bbb'),
('ÄÄ');

prepare st from 'select * from t where s like ? ';
execute st using '_B_';
execute st using 'ää';
execute st using '_B_' collate utf8_gen_ci;
alter table t change column s s string collate utf8_bin;
execute st using '_B_';
deallocate prepare st;

set names utf8 collate utf8_gen_ci;
prepare st1 from 'select 1 from db_class where ? like ''%B'' limit 1';
execute st1 using 'bb';
set names utf8 collate utf8_gen;
execute st1 using 'bb';
deallocate prepare st;
drop t;

set names utf8;
create table t(s string collate utf8_bin);
create index i on t(right(s,2));
insert into t values
('_bb'),
('bb'),
('bbb'),
(NULL),
('_bbb'),
('ÄÄ');

prepare st from 'select * from t where s like ? ';
execute st using '_B_';
set names utf8 collate utf8_gen_ci;
execute st using '_B_';
deallocate prepare st;
drop t;

set names iso88591;
set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';
--+ holdcas off;
