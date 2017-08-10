--+ holdcas on;
set names utf8;
--mixdey ; range search
create class test_cn (i integer,s CHAR(5) collate utf8_gen,j integer,t varCHAR(10) collate utf8_gen,x CHAR(6) collate utf8_gen );
insert into test_cn values(101, '风雨雷电露', 100001, '苹果香蕉葡萄西瓜蜜桔', '苹果西柚水露');
insert into test_cn values(101, '风雨雷电霜', 100002, '鱿鱼香蕉葡萄西瓜龙虾', '鱿鱼西柚水露');
insert into test_cn values(101, '风雨雷电冰', 100003, '螃蟹香蕉葡萄西瓜螃蟹', '西柚石榴露');
insert into test_cn values(101, '风雨雷电水', 100004, '龙虾香蕉葡萄西瓜鱿鱼', '西柚水露');
insert into test_cn values(101, '露云水光天', 100005, '霜猕猴金鱼西瓜苹果', '西柚水露');
create unique index foo_udx on test_cn (i, s, j, t);
create index int_idx on test_cn (i, j);

insert into test_cn values(102, '风雨雷电露', 100001, '苹果香蕉葡萄西瓜蜜桔', '苹果西柚水露');
insert into test_cn values(102, '风雨雷电霜', 100002, '鱿鱼香蕉葡萄西瓜龙虾', '鱿鱼西柚水露');
insert into test_cn values(102, '风雨雷电冰', 100003, '螃蟹香蕉葡萄西瓜螃蟹', '西柚水露');
insert into test_cn values(102, '风雨雷电水', 100004, '龙虾香蕉葡萄西瓜鱿鱼', '西柚水露');
insert into test_cn values(102, '露云水光天', 100005, '霜猕猴金鱼西瓜苹果', '西柚水露');
select * from test_cn where i = 101 and s >= '风雨雷电冰' and s <= '风雨雷电火' order by s;

select * from test_cn where i = 102 and s IN { '风雨雷电露' , '风雨雷电冰'}  and x between '苹果西柚水露' and '西柚水天'  order by x;


drop class test_cn;
set names iso88591;
commit;
--+ holdcas off;



