--+ holdcas on;
set names utf8;
--Test using indexes in a select query
create class test_cn (i integer,s STRING collate utf8_gen,j integer,t STRING collate utf8_gen,x STRING collate utf8_gen );
create unique index foo_udx on test_cn (i, s, j, t);
create index int_idx on test_cn (i, j);
insert into test_cn values(101, '雨霜露桃火', 100001, '苹果菠萝桃西瓜雪', '苹果香蕉细雨');
insert into test_cn values(102, '雨霜露桃雪', 100002, '蜜桔菠萝桃西瓜枣', '蜜桔香蕉细雨');
insert into test_cn values(103, '雨霜露桃冰', 100003, '柳菠萝桃西瓜柳', '香蕉细雨');
insert into test_cn values(104, '雨霜露桃细', 100004, '枣菠萝桃西瓜蜜桔', '香蕉细雨');
insert into test_cn values(105, '雨霜露桃云', 100005, '雪菠萝桃西瓜苹果', '香蕉细雨');

select * from test_cn where i = 101 and j = 100001 order by i;

select * from test_cn where i = 101 and j = 100001 using index foo_udx order by j;


select * from test_cn where s = '雨霜露桃雪' and x = '蜜桔香蕉细雨' order by s;

select * from test_cn where s = '雨霜露桃雪' and x = '蜜桔香蕉细雨' using index foo_udx order by x;

select * from test_cn where s = '雨霜露桃雪' and t = '蜜桔菠萝桃西瓜枣' order by x;

select * from test_cn where t = '枣菠萝桃西瓜蜜桔' or x = '香蕉细雨' order by s;

select * from test_cn where t = '枣菠萝桃西瓜蜜桔' or x = '香蕉细雨' using index foo_udx(+) order by t;

select * from test_cn where i = 101 or t = '枣菠萝桃西瓜蜜桔' using index int_idx, foo_udx  order by i;

select * from test_cn where i = 101 or t = '枣菠萝桃西瓜蜜桔' using index int_idx(+), foo_udx(+)  order by x;

select * from test_cn where i = 101 or t = '枣菠萝桃西瓜蜜桔' using index none  order by t;

drop class test_cn;
set names iso88591;
commit;
--+ holdcas off;


