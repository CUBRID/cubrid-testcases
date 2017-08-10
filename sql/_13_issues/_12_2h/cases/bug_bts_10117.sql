set names utf8;

drop table if exists t;
create table t(s string) collate utf8_en_ci partition by list(s) (partition p0 values in ('a'),partition p1 values in ('A'));
create table t(s string) collate utf8_de_exp_ai_ci partition by list(s) (partition p0 values in ('AE'),partition p1 values in ('ä'),partition p2 values in('Ä'));

create table t(s string) collate utf8_de_exp_ai_ci partition by list(s) (partition p0 values in ('ß'),partition p1 values in ('SS'));
create table t(s string collate utf8_ja_exp_cbm) partition by list(s)(partition p0 values in ('ァー'),partition p1 values in ('ｧー'));

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

create table t(s string collate utf8_de_exp) partition by range(s) (partition p0 values less than('Ä'),partition p1 values less than ('Ä'));

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

set names iso88591;
