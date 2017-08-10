--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( sh1 short, i1 int, b1 bigint, n1 numeric, f1 float, d1 double, m1 monetary);

insert into test_tr values (195, 195,195,195,195,195,195);
insert into test_tr values (193, 193,193,193,193,193,193);
insert into test_tr values (191, 191,191,191,191,191,191);
insert into test_tr values (0, 0,0,0,0,0,0);
insert into test_tr values (null, null,null,null,null,null,0);
--test
select chr(sh1), chr(i1), chr (b1), chr(n1) , chr (f1), chr (d1), chr (m1) from test_tr;
--test
select chr(sh1+2), chr(i1+2), chr (b1+2), chr(n1+2) , chr (f1+2), chr (d1+2), chr (m1+2) from test_tr;
--test
select chr(sh1-2), chr(i1-2), chr (b1-2), chr(n1-2) , chr (f1-2), chr (d1-2), chr (m1-2) from test_tr;
drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;
