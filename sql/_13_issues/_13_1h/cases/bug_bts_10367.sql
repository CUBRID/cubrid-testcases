--TEST: [I18N] IF function doesn't work well with CHARSET AND COLLATION function.

set names utf8;

create table t1 (id int, a varchar(10) charset utf8 collate utf8_en_ci, b varchar(10) charset iso88591 collate iso88591_en_cs);
insert into t1 values (1, 'A', 'B'), (2, 'a', 'b');

select charset(case when id=1 then _utf8'a' else _iso88591'b' end), collation(case when id=1 then _utf8'a' else _iso88591'b' collate iso88591_en_ci end) from t1;
select charset(case when id=1 then _utf8'a' else a end), collation(case when id=1 then _utf8'a' else a end) from t1;
select charset(case when id=1 then _utf8'a' else b end), collation(case when id=1 then _utf8'a' else b end) from t1;
select charset(case when id=1 then a else b end), collation(case when id=1 then a else b end) from t1;


--field
select field(_utf8'abc', _iso88591'abc' collate iso88591_en_ci, _utf8'abc');
select field(_utf8'abc', _iso88591'ABC' collate iso88591_en_cs, _utf8'abc');
select field(_utf8'abc', _iso88591'AC' collate iso88591_en_ci, _utf8'ABC');
select field(_utf8'abc', _iso88591'AC' collate iso88591_en_cs, _utf8'ABC');
select field(_utf8'abc' collate utf8_en_ci , _iso88591'AC' collate iso88591_en_cs, _utf8'ABC');
select id, field('B', b, 'B') from t1 order by id;


drop table t1;

set names iso88591;

