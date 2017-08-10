--+ holdcas on;
set names utf8;
--mixdey ; data inserted after index is created 
create class test_cn (i integer,s CHAR(5) collate utf8_gen,j integer,t varCHAR(10) collate utf8_gen,x CHAR(6) collate utf8_gen );
create unique index foo_udx on test_cn (i, s, j, t);
create index int_idx on test_cn (i, j);
insert into test_cn values(101, '风雨雷电露', 100001, '苹果香蕉葡萄西瓜蜜桔', '苹果西柚水露');
insert into test_cn values(102, '风雨雷电霜', 100002, '鱿鱼香蕉葡萄西瓜龙虾', '鱿鱼西柚水露');
insert into test_cn values(103, '风雨雷电冰', 100003, '螃蟹香蕉葡萄西瓜螃蟹', '西柚水露');
insert into test_cn values(104, '风雨雷电水', 100004, '龙虾香蕉葡萄西瓜鱿鱼', '西柚水露');
insert into test_cn values(105, '露云水光天', 100005, '霜猕猴金鱼西瓜苹果', '西柚水露');

select * from test_cn where i = 101 and j = 100001 order by i;

select * from test_cn where i = 101 and j = 100001 using index foo_udx order by j;


select * from test_cn where s = '风雨雷电霜' and x = '鱿鱼西柚水露' order by s;

select * from test_cn where s = '风雨雷电霜' and x = '鱿鱼西柚水露' using index foo_udx order by x;

select * from test_cn where s = '风雨雷电霜' and t = '鱿鱼香蕉葡萄西瓜龙虾' order by x;

select * from test_cn where t = '龙虾香蕉葡萄西瓜鱿鱼' or x = '西柚水露' order by s;

select * from test_cn where t = '龙虾香蕉葡萄西瓜鱿鱼' or x = '西柚水露' using index foo_udx(+) order by t;

select * from test_cn where i = 101 or t = '龙虾香蕉葡萄西瓜鱿鱼' using index int_idx, foo_udx  order by i;

select * from test_cn where i = 101 or t = '龙虾香蕉葡萄西瓜鱿鱼' using index int_idx(+), foo_udx(+)  order by x;

select * from test_cn where i = 101 or t = '龙虾香蕉葡萄西瓜鱿鱼' using index none  order by t;

drop class test_cn;
set names iso88591;
commit;
--+ holdcas off;



