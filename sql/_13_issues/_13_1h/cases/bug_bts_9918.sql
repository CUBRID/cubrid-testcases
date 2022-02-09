--TEST: [I18N] IF function doesn't work well with CHARSET AND COLLATION function.

set names utf8;

create table t1 (id int, a varchar(10) charset utf8 collate utf8_en_ci, b varchar(10) charset iso88591 collate iso88591_en_ci);
insert into t1 values (1, 'A', 'a'), (2, 'B', 'b');

select charset(if(id%2<>0,  _utf8'a', _iso88591'b')), collation(if(id%2<>0,  _utf8'a', _iso88591'b' collate iso88591_en_ci)) from t1;
select charset(if(id%2<>0,  _utf8'a', a)), collation(if(id%2<>0,  _utf8'a', a)) from t1;
select charset(if(id%2<>0,  _utf8'a', b)), collation(if(id%2<>0,  _utf8'a', b)) from t1;
select charset(if(id%2<>0,  a, b)), collation(if(id%2<>0,  a, b)) from t1;


select charset(decode(id, 1, _utf8'a', 2, _iso88591'b')), collation(decode(id, 1, _utf8'a', 2, _iso88591'b' collate iso88591_en_ci)) from t1; 
select charset(decode(id, 1, _utf8'a', 2, a)), collation(decode(id, 1, _utf8'a', 2, a)) from t1; 
select charset(decode(id, 1, _utf8'a', 2, b)), collation(decode(id, 1, _utf8'a', 2, b)) from t1; 
select charset(decode(id, 1, a, 2, b)), collation(decode(id, 1, a, 2, b)) from t1;


drop table t1;

set names iso88591;

