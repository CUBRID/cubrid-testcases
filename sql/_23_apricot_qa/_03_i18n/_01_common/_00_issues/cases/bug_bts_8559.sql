set names utf8;
select ('월' rlike '월$');
select ('월' regexp '월$');
select ('a월a' rlike '월$');
select ('월$' rlike '[a]월$');
select ('월' rlike '^월');
select ('a월' rlike '^월$');
select ('월' rlike '^월$');
select ('ba' rlike 'a$');

set names iso88591;
select ('월' rlike '월$');

