autocommit off;
set names iso88591 collate iso88591_en_ci;

select INDEX_PREFIX('sys','wsÖ','A');
select INDEX_PREFIX('wsÖ','sys','D');
select INDEX_PREFIX ('ab c', 'ab', 'd');


set names utf8 collate utf8_en_ci;

select INDEX_PREFIX('sys','wsÖ','A');
select INDEX_PREFIX('wsÖ','sys','D');
select INDEX_PREFIX ('ab c', 'ab', 'd');


set names utf8 collate utf8_ko_cs_uca;

select INDEX_PREFIX('sys','wsÖ','A');
select INDEX_PREFIX('wsÖ','sys','D');
select INDEX_PREFIX ('ab c', 'ab', 'd');


set names iso88591;
commit;
autocommit on;