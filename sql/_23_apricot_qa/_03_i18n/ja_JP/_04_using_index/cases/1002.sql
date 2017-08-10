--+ holdcas on;
set names utf8;
--Test using indexes in a select query
create class test_jp (i integer,s string collate utf8_ja_exp,j integer,t string collate utf8_ja_exp,x string collate utf8_ja_exp );
create unique index foo_udx on test_jp (i, s, j, t);
create index int_idx on test_jp (i, j);
insert into test_jp values(101, '=d発はQ', 100001, '沢麼は樹ヰ', '沢語ぁ=');
insert into test_jp values(102, '=d発はヰ', 100002, '岡麼は樹師', '岡語ぁ=');
insert into test_jp values(103, '=d発は发', 100003, '擦麼は樹擦', '語ぁ=');
insert into test_jp values(104, '=d発はぁ', 100004, '師麼は樹岡', '語ぁ=');
insert into test_jp values(105, '=d発は遠', 100005, 'ヰ麼は樹沢', '語ぁ=');

select * from test_jp where i = 101 and j = 100001 order by i;

select * from test_jp where i = 101 and j = 100001 using index foo_udx order by j;


select * from test_jp where s = '=d発はヰ' and x = '岡語ぁ=' order by s;

select * from test_jp where s = '=d発はヰ' and x = '岡語ぁ=' using index foo_udx order by x;

select * from test_jp where s = '=d発はヰ' and t = '岡麼は樹師' order by x;

select * from test_jp where t = '師麼は樹岡' or x = '語ぁ=' order by s;

select * from test_jp where t = '師麼は樹岡' or x = '語ぁ=' using index foo_udx(+) order by t;

select * from test_jp where i = 101 or t = '師麼は樹岡' using index int_idx, foo_udx  order by i;

select * from test_jp where i = 101 or t = '師麼は樹岡' using index int_idx(+), foo_udx(+)  order by x;

select * from test_jp where i = 101 or t = '師麼は樹岡' using index none  order by t;

drop class test_jp;
set names iso88591;
commit;
--+ holdcas off;

