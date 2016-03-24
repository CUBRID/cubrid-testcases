
set names iso88591;
select charset('abc'), if(charset('abc')='iso88591', 'OK','NOK');
select charset(''), if(charset('')='iso88591', 'OK','NOK');
select charset('~*. '), if(charset('~*. ')='iso88591', 'OK','NOK');

set names utf8;
select charset('abc'), if(charset('abc')='utf8', 'OK','NOK');
select charset(''), if(charset('')='utf8', 'OK','NOK');
select charset('~*. '), if(charset('~*. ')='utf8', 'OK','NOK');

set names euckr;
select charset('abc'), if(charset('abc')='euckr', 'OK','NOK');
select charset(''), if(charset('')='euckr', 'OK','NOK');
select charset('~*. '), if(charset('~*. ')='euckr', 'OK','NOK');

set names iso88591;
