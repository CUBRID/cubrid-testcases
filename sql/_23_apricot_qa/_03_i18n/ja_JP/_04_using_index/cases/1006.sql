--+ holdcas on;
set names utf8;
--mixdey ; range search
create class test_jp (i integer,s char(5)  collate utf8_ja_exp,j integer,t varchar(5)  collate utf8_ja_exp,x char(4)  collate utf8_ja_exp );
insert into test_jp values(101, '=d発は=', 100001, '沢麼は樹ヰ', '沢語ぁ=');
insert into test_jp values(101, '=d発はヰ', 100002, '岡麼は樹師', '岡語ぁ=');
insert into test_jp values(101, '=d発は发', 100003, '擦麼は樹擦', '語ぁ=');
insert into test_jp values(101, '=d発はぁ', 100004, '師麼は樹岡', '語ぁ=');
insert into test_jp values(101, '=dぁ它遠', 100005, 'ヰ上亜樹沢', '語ぁ=');
create unique index foo_udx on test_jp (i, s, j, t);
create index int_idx on test_jp (i, j);

insert into test_jp values(102, '=d発は=', 100001, '沢麼は樹ヰ', '沢語ぁ=');
insert into test_jp values(102, '=d発はヰ', 100002, '岡麼は樹師', '岡語ぁ=');
insert into test_jp values(102, '=d発は发', 100003, '擦麼は樹擦', '語ぁ=');
insert into test_jp values(102, '=d発はぁ', 100004, '師麼は樹岡', '語ぁ=');
insert into test_jp values(102, '=dぁ它遠', 100005, 'ヰ上亜樹沢', '語ぁ=');

select * from test_jp where i = 101 and s >= '=d発は发' and s <= '=d発は发' order by s;
select * from test_jp where i = 102 and s IN { '=d発は=' , '=d発は发'};
select * from test_jp where i = 102 and s IN { '=d発は=' , '=d発は发'}  and x between '沢語ぁ=' and '語ぁ遠'  order by x;


drop class test_jp;
set names iso88591;
commit;
--+ holdcas off;

