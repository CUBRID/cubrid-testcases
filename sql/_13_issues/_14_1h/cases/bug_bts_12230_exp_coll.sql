autocommit off;
set names utf8 collate utf8_de_exp;

select INDEX_PREFIX('aBcd','abdd','A');

select INDEX_PREFIX('abdd','aBcd','D');


select INDEX_PREFIX('aBcd','abd','A');

select INDEX_PREFIX('abd','aBcd','D');



select INDEX_PREFIX('aBc','abdd','A');

select INDEX_PREFIX('abdd','aBc','D');


select INDEX_PREFIX('F','fac','A');

select INDEX_PREFIX('fac','F','D');


select INDEX_PREFIX('F','f','A');

select INDEX_PREFIX('f','F','D');


select INDEX_PREFIX('CMŞ','ÇmS','A');

select INDEX_PREFIX('ÇmS','CMŞ','D');

select INDEX_PREFIX ('ab c', 'ab', 'd');


select INDEX_PREFIX ('ab', 'ab  c', 'a');

set names iso88591;
commit;
autocommit on;