set names utf8;

select chr(65) collate utf8_ko_cs;
select substr(user(),1,locate('@',user())) collate utf8_en_ci;
select 1 from db_class where user() collate iso88591_en_ci is not null limit 1;
select 1 from db_class where DATABASE() collate iso88591_en_ci is not null limit 1;
select 1 from db_class where SCHEMA() collate iso88591_en_ci is not null limit 1;
select 1 from db_class where VERSION() collate iso88591_en_ci is not null limit 1;
select substr('aa',2) collate iso88591_bin;
select substr('aa',2) collate utf8_bin;

set names iso88591;
select chr(65) collate iso88591_en_ci;
select chr(65) collate utf8_ko_cs;
select 1 from db_class where SCHEMA() is not null limit 1;
select substr('aa',2) collate iso88591_bin;
select substr('aa',2) collate utf8_bin;
