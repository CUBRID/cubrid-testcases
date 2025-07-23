set names utf8;

select 1 from db_class where ('B'>'a') collate iso88591_en_ci limit 1;
select 1 from db_class where (_utf8'B'>_utf8'a') collate iso88591_en_ci limit 1;
select 1 from db_class where (_iso88591'B'>_iso88591'a') collate iso88591_en_ci limit 1;
select 1 from db_class where 'B' collate iso88591_en_ci > 'a' collate iso88591_en_ci limit 1;

set names iso88591;
select 1 from db_class where ('B'>'a') collate iso88591_en_ci limit 1;
select 1 from db_class where ('B'>'a') collate iso88591_en_cs limit 1;

set names iso88591;
