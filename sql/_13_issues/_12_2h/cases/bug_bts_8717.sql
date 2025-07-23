--+ holdcas on;
set names utf8 collate utf8_en_ci;
select SET{'A', 'a'};

set names iso88591 collate iso88591_en_ci;

select SET{'A', 'a'};
set names iso88591;
commit;
--+ holdcas off;
