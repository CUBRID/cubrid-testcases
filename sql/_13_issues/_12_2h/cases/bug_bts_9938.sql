set names utf8;

select class_name from db_class order by 1 collate utf8_bin limit 1;
--select class_name from db_class order by ascii('a') collate utf8_gen limit 1;
--select class_name from db_class order by length(' ') collate utf8_fr_exp_ab limit 1;
select * from db_class order by 1,2 collate utf8_bin,3 limit 1;

set names iso88591;
