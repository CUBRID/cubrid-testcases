--+ holdcas on;
set names utf8;
--mixdey ; range search
create class test_kh (i integer,s char(5) collate utf8_km_exp,j integer,t varchar(5) collate utf8_km_exp,x char(4) collate utf8_km_exp );
insert into test_kh values(101, 'ឯឡ៏ខឯ', 100001, '៩៝ខ០ត', '៩នកឯ');
insert into test_kh values(101, 'ឯឡ៏ខត', 100002, 'ឦ៝ខ០ា', 'ឦនកឯ');
insert into test_kh values(101, 'ឯឡ៏ខះ', 100003, '៘៝ខ០៘', 'នកឯ');
insert into test_kh values(101, 'ឯឡ៏ខក', 100004, 'ា៝ខ០ឦ', 'នកឯ');
insert into test_kh values(101, 'ឯឡក៣៰', 100005, 'ត៴ឰ០៩', 'នកឯ');
create unique index foo_udx on test_kh (i, s, j, t);
create index int_idx on test_kh (i, j);

insert into test_kh values(102, 'ឯឡ៏ខឯ', 100001, '៩៝ខ០ត', '៩នកឯ');
insert into test_kh values(102, 'ឯឡ៏ខត', 100002, 'ឦ៝ខ០ា', 'ឦនកឯ');
insert into test_kh values(102, 'ឯឡ៏ខះ', 100003, '៘៝ខ០៘', 'នកឯ');
insert into test_kh values(102, 'ឯឡ៏ខក', 100004, 'ា៝ខ០ឦ', 'នកឯ');
insert into test_kh values(102, 'ឯឡក៣៰', 100005, 'ត៴ឰ០៩', 'នកឯ');

select * from test_kh where i = 101 and s >= 'ឯឡ៏ខះ' and s <= 'ឯឡ៏ខហ' order by s;

select * from test_kh where i = 102 and s IN { 'ឯឡ៏ខឯ' , 'ឯឡ៏ខះ'}  and x between '៩នកឯ' and 'នក៰'  order by x;


drop class test_kh;
set names iso88591;
commit;
--+ holdcas off;

