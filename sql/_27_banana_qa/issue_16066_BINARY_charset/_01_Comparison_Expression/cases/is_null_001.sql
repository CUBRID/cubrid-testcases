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


set names binary;
select * from t where col_binary is null;
select * from t where col_binary = null ;
select id, col_binary ,col_euckr ,col_utf8, col_iso from t where col_binary is not null and id < 4 order by id;
select id, col_binary ,HEX(col_euckr) ,col_utf8, col_iso from t where col_binary is not null and id >= 4 order by id;
select id, col_binary ,col_euckr ,col_utf8, col_iso  from t where repeat(col_binary,1024*1024) is  null and id < 4 order by id;
select id, col_binary ,HEX(col_euckr ),col_utf8, col_iso  from t where repeat(col_binary,1024*1024) is  null and id >= 4 order by id;



drop table t;

set names iso88591;
--+ holdcas off;