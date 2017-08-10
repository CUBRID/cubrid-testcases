--+ holdcas on;
set names utf8;

drop table if exists t;

create table t(i int,s1 string,s2 string charset iso88591);
insert into t values(1,' ',' '),(2,'$','$'),(3,'A','A'),(4,'D','D'),(5,'0','0'),(6,'a','a'),(7,'d','d'),(8,'~','~'),(9,'Ç','Ç'),(10,'ă','ă'),(11,'工','工');
select s1 collate iso88591_en_ci as k,i from t order by k,i;
select s2 collate iso88591_en_ci as k,i from t order by k,i;
drop t;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';
select t1.c1,t1.c2 from (select 'Ä' collate utf8_de_exp as c1,'AE' collate utf8_de_exp as c2) t1 where t1.c1>t1.c2; 
select t1.c1,t1.c2 from (select _iso88591'Ä' collate utf8_de_exp as c1,_iso88591'AE' collate utf8_de_exp as c2) t1 where t1.c1>t1.c2;
set names iso88591 collate iso88591_bin;
select t1.c1,t1.c2 from (select _utf8'Ä' collate utf8_de_exp as c1,_utf8'AE' collate utf8_de_exp as c2) t1 where t1.c1>t1.c2;

set names utf8 collate utf8_bin;

select NULL collate utf8_bin as k;
select 'ß' collate utf8_gen as k,'가' collate utf8_gen as l,'ü' as m;
set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

set names iso88591;
commit;
--+ holdcas off;


