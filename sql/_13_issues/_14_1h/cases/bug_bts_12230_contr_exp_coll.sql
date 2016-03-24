autocommit off;
set names utf8 collate utf8_ja_exp;

select INDEX_PREFIX('sysぁゝ','sysぁ','A');
select INDEX_PREFIX('sysぁ','sysぁゝ','D');

select INDEX_PREFIX('sysぁゝa','sysぁa','A');
select INDEX_PREFIX('sysぁa','sysぁゝa','D');

select INDEX_PREFIX('sysぁゝa','sysぁb','A');
select INDEX_PREFIX('sysぁb','sysぁゝa','D');


select INDEX_PREFIX('sysぁゝ','sysぃゝ','A');
select INDEX_PREFIX('sysぃゝ','sysぁゝ','D');

select INDEX_PREFIX('sysぁゝa','sysぃゝa','A');
select INDEX_PREFIX('sysぃゝa','sysぁゝa','D');

select INDEX_PREFIX('sysぁゝa','sysぃゝb','A');
select INDEX_PREFIX('sysぃゝb','sysぁゝa','D');

select INDEX_PREFIX('sysぁゝa','sysぃゝ','A');
select INDEX_PREFIX('sysぃゝa','sysぁゝ','D');

select INDEX_PREFIX ('ab c', 'ab', 'd');

set names iso88591;
commit;
autocommit on;