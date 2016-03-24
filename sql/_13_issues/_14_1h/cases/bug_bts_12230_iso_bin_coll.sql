autocommit off;
set names iso88591 collate iso88591_bin;

select INDEX_PREFIX('abc','abcd','A');
select INDEX_PREFIX('abcd','abc','d');

select INDEX_PREFIX('abc','abc  d','A');
select INDEX_PREFIX ('abc  d', 'abc', 'd');
select INDEX_PREFIX ('ab c', 'ab', 'd');

select INDEX_PREFIX('abc','c','A');
select INDEX_PREFIX ('c', 'abc', 'd');


set names utf8 collate utf8_bin;

select INDEX_PREFIX('abc','abcd','A');
select INDEX_PREFIX('abcd','abc','d');

select INDEX_PREFIX('abc','abc  d','A');
select INDEX_PREFIX ('abc  d', 'abc', 'd');
select INDEX_PREFIX ('ab c', 'ab', 'd');

select INDEX_PREFIX('abc','c','A');
select INDEX_PREFIX ('c', 'abc', 'd');


set names euckr collate euckr_bin;

select INDEX_PREFIX('abc','abcd','A');
select INDEX_PREFIX('abcd','abc','d');

select INDEX_PREFIX('abc','abc  d','A');
select INDEX_PREFIX ('abc  d', 'abc', 'd');
select INDEX_PREFIX ('ab c', 'ab', 'd');

select INDEX_PREFIX('abc','c','A');
select INDEX_PREFIX ('c', 'abc', 'd');

select INDEX_PREFIX (_euckr'10369          ', cast ('1037' as CHAR (10) charset euckr), 'a');

select INDEX_PREFIX (cast ('10369' as CHAR(10) charset euckr), '1037       ' , 'a');

select INDEX_PREFIX (cast ('1037' as CHAR (10) charset euckr), _euckr'10369          ', 'd');

select INDEX_PREFIX (_euckr'1037        ' , cast('10369' as CHAR(10) charset euckr), 'd');


set names iso88591 collate iso88591_en_ci;

select INDEX_PREFIX('abc','abcd','A');
select INDEX_PREFIX('abcd','abc','d');

select INDEX_PREFIX('abc','abc  d','A');
select INDEX_PREFIX ('abc  d', 'abc', 'd');
select INDEX_PREFIX ('ab c', 'ab', 'd');

select INDEX_PREFIX('abc','c','A');
select INDEX_PREFIX ('c', 'abc', 'd');


set names utf8 collate utf8_en_ci;

select INDEX_PREFIX('abc','abcd','A');
select INDEX_PREFIX('abcd','abc','d');

select INDEX_PREFIX('abc','abc  d','A');
select INDEX_PREFIX ('abc  d', 'abc', 'd');
select INDEX_PREFIX ('ab c', 'ab', 'd');

select INDEX_PREFIX('abc','c','A');
select INDEX_PREFIX ('c', 'abc', 'd');

set names iso88591;
commit;
autocommit on;