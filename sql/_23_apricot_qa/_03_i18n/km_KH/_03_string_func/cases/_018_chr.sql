--+ holdcas on;
set names utf8;
CREATE TABLE test_kh ( sh1 short, i1 int, b1 bigint, n1 numeric, f1 float, d1 double, m1 monetary);

insert into test_kh values (193, 193,193,193,193,193,193);

select chr(sh1), chr(i1), chr (b1), chr(n1) , chr (f1), chr (d1), chr (m1) from test_kh;

drop table test_kh;
set names iso88591;
commit;
--+ holdcas off;
