--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (
id int AUTO_INCREMENT , 
col_binary varchar(100) collate binary, 
col_euckr  varchar(100) collate euckr_bin, 
col_utf8    varchar(100) collate utf8_bin, 
col_iso      varchar(100) collate iso88591_bin);

insert into t values(null,null,null,null,null);
insert into t values(null,'CUBRID', 'CUBRID', 'CUBRID',  'CUBRID');
insert into t values(null,'큐브리드','큐브리드', '큐브리드', '큐브리드');
insert into t values(null,'你好我好大家好', '你好我好大家好', '你好我好大家好', '你好我好大家好');
insert into t values(null,'ÀÀÏ', 'ÀÀÏ', 'ÀÀÏ',  'ÀÀÏ');
insert into t values(null, '你我他','你我他', '你我他', '你我他');
insert into t values(null, '你%我%他','你我他', '你我他', '你我他');

set names binary;
select col_binary from t where col_binary like '%你%';
select col_binary from t where col_binary not like '%你%';
select col_binary from t where col_binary like '_你%';
select col_binary from t where col_binary not like '_你%';
select col_binary from t where col_binary like '____';
select col_binary from t where col_binary not like '____';

set system parameters 'no_backslash_escapes=no';
set system parameters 'require_like_escape_character=yes';
select col_binary from t where col_binary  like '%\%我%';

set system parameters 'require_like_escape_character=no';
set system parameters 'no_backslash_escapes=y';

drop table t;

set names iso88591;
--+ holdcas off;
