set names utf8 collate utf8_gen_ci;

select ('a' collate utf8_en_ci regexp binary 'A' collate utf8_en_ci);
select ('a' collate utf8_en_cs regexp binary 'A' collate utf8_en_cs);

select ('a' collate utf8_en_ci regexp 'A' collate utf8_en_ci);
select ('a' collate utf8_en_cs regexp 'A' collate utf8_en_cs); 

select ('a' collate utf8_en_ci regexp binary 'A' collate utf8_en_cs); 
select ('a' collate utf8_en_cs regexp binary 'A' collate utf8_en_ci); 

select ('a' collate utf8_en_ci regexp  'A' collate utf8_en_cs);   
select ('a' collate utf8_en_cs regexp 'A' collate utf8_en_ci);     

set names iso88591;

