drop table if exists test_tbl, test_int, test_short, test_bigint, test_float, test_float_n, test_double, test_numeric, test_numeric_n;

create table test_tbl ( print_ord numeric(3,0) not null );
insert into test_tbl select rownum *5
from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d limit 1000;

select max(print_ord) from test_tbl;
select rownum, print_ord from test_tbl order by print_ord desc limit 10;

create table test_int (a int);
insert into test_int select -2147483647 - rownum;
 --error
insert into test_int select -2147483648 - rownum;
insert into test_int select 2147483646 + rownum;
 --error
insert into test_int select 2147483647 + rownum;
select * from test_int order by 1;


create table test_short (a short);
insert into test_short select -32767 - rownum;
 --error
insert into test_short select -32768 - rownum;
insert into test_short select 32766 + rownum;
 --error
insert into test_short select 32767 + rownum;
select * from test_short order by 1;


create table test_bigint (a bigint);
insert into test_bigint select -9223372036854775807 - rownum;
 --error
insert into test_bigint select -9223372036854775808 - rownum;
insert into test_bigint select 9223372036854775806 + rownum;
 --error
insert into test_bigint select 9223372036854775807 + rownum;
select * from test_bigint order by 1;

create table test_float (i int, a float);
insert into test_float select 1, -3.402823465E+38 - rownum;
insert into test_float values(2, -3.402823466E+38);
insert into test_float select 3, -3.402823466E+38 - rownum;
 --error
insert into test_float values(4, -3.402823467E+38);
insert into test_float select 5, 3.402823465E+38 + rownum;
insert into test_float values(6, 3.402823466E+38);
insert into test_float select 7, 3.402823466E+38 + rownum;
 --error
insert into test_float values(8, 3.402823467E+38);
select * from test_float order by 1;

create table test_float_n (i int, a float(7), b float(38));
insert into test_float_n(i,a) select 1, 3.402823465E+38 + rownum;
insert into test_float_n(i,a) values(2, 3.402823466E+38);
insert into test_float_n(i,b) select 3, 3.402823465E+38 + rownum;
insert into test_float_n(i,b) values(4, 3.402823466E+38);
insert into test_float_n(i,a) select 5, 3.402823466E+38 + rownum;
 --error
insert into test_float_n(i,a) values(6, 3.402823467E+38);
insert into test_float_n(i,b) select 7, 3.402823466E+38 + rownum;
insert into test_float_n(i,b) values(8, 3.402823467E+38);
select * from test_float_n order by 1;

create table test_double (i int, a double);
insert into test_double(i,a) select 1, -1.7976931348623156E+308 - rownum; 
insert into test_double(i,a) values(2, -1.7976931348623157E+308);
insert into test_double(i,a) select 3, -1.7976931348623157E+308 - rownum; 
insert into test_double(i,a) values(4, -1.7976931348623158E+308);
insert into test_double(i,a) select 5, 1.7976931348623156E+308 + rownum; 
insert into test_double(i,a) values(6, 1.7976931348623157E+308);
insert into test_double(i,a) select 7, 1.7976931348623157E+308 + rownum; 
insert into test_double(i,a) values(8, 1.7976931348623158E+308);
select * from test_double order by 1;

create table test_numeric (a numeric);
insert into test_numeric select -999999999999998 - rownum;
 --error
insert into test_numeric select -999999999999999 - rownum;
insert into test_numeric select 999999999999998 + rownum;
 --error
insert into test_numeric select 999999999999999 + rownum;
select * from test_numeric order by 1;

create table test_numeric_n (ai int auto_increment, a numeric(1), b numeric(2), c numeric(3), d numeric(4), e numeric(5), f numeric(6), g numeric(7), h numeric(8), i numeric(9), j numeric(10), 
k numeric(11), l numeric(12), m numeric(13), n numeric(14), o numeric(15), p numeric(16), q numeric(17), r numeric(18), s numeric(19), t numeric(20));
insert into test_numeric_n(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t) select 8 + rownum a, 98 + rownum b, 998 + rownum c, 9998 + rownum d, 99998 + rownum e, 999998 + rownum f, 9999998 + rownum g, 99999998 + rownum h, 999999998 + rownum i, 9999999998 + rownum j,
99999999998 + rownum k, 999999999998 + rownum l, 9999999999998 + rownum m, 99999999999998 + rownum n, 999999999999998 + rownum o, 9999999999999998 + rownum p, 99999999999999998 + rownum q, 999999999999999998 + rownum r, 9999999999999999998 + rownum s, 99999999999999999998 + rownum t;
insert into test_numeric_n(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t) select -8 - rownum a, -98 - rownum b, -998 - rownum c, -9998 - rownum d, -99998 - rownum e, -999998 - rownum f, -9999998 - rownum g, -99999998 - rownum h, -999999998 - rownum i, -9999999998 - rownum j,
-99999999998 - rownum k, -999999999998 - rownum l, -9999999999998 - rownum m, -99999999999998 - rownum n, -999999999999998 - rownum o, -9999999999999998 - rownum p, -99999999999999998 - rownum q, -999999999999999998 - rownum r, -9999999999999999998 - rownum s,-99999999999999999998 - rownum t;
 --error
insert into test_numeric_n(a) select 9 + rownum;
insert into test_numeric_n(b) select 99 + rownum;
insert into test_numeric_n(c) select 999 + rownum;
insert into test_numeric_n(d) select 9999 + rownum;
insert into test_numeric_n(e) select 99999 + rownum;
insert into test_numeric_n(f) select 999999 + rownum;
insert into test_numeric_n(g) select 9999999 + rownum;
insert into test_numeric_n(h) select 99999999 + rownum;
insert into test_numeric_n(i) select 999999999 + rownum;
insert into test_numeric_n(j) select 9999999999 + rownum;
insert into test_numeric_n(k) select 99999999999 + rownum;
insert into test_numeric_n(l) select 999999999999 + rownum;
insert into test_numeric_n(m) select 9999999999999 + rownum;
insert into test_numeric_n(n) select 99999999999999 + rownum;
insert into test_numeric_n(o) select 999999999999999 + rownum;
insert into test_numeric_n(p) select 9999999999999999 + rownum;
insert into test_numeric_n(q) select 99999999999999999 + rownum;
insert into test_numeric_n(r) select 999999999999999999 + rownum;
insert into test_numeric_n(s) select 9999999999999999999 + rownum;
insert into test_numeric_n(t) select 99999999999999999999 + rownum;
insert into test_numeric_n(a) select 999999999999999999999 + rownum;
insert into test_numeric_n(b) select 99999999999999999999999 + rownum;
insert into test_numeric_n(c) select 999999999999999999999999 + rownum;
insert into test_numeric_n(d) select 9999999999999999999999999 + rownum;
insert into test_numeric_n(e) select 99999999999999999999999999 + rownum;
insert into test_numeric_n(f) select 999999999999999999999999999 + rownum;
insert into test_numeric_n(g) select 9999999999999999999999999999 + rownum;
insert into test_numeric_n(h) select 99999999999999999999999999999 + rownum;
insert into test_numeric_n(i) select 999999999999999999999999999999 + rownum;
insert into test_numeric_n(j) select 9999999999999999999999999999999 + rownum;
insert into test_numeric_n(k) select 99999999999999999999999999999999 + rownum;
insert into test_numeric_n(l) select 999999999999999999999999999999999 + rownum;
insert into test_numeric_n(m) select 9999999999999999999999999999999999 + rownum;
insert into test_numeric_n(n) select 99999999999999999999999999999999999 + rownum;
insert into test_numeric_n(o) select 999999999999999999999999999999999999 + rownum;
insert into test_numeric_n(p) select 99999999999999999999999999999999999999 + rownum;
insert into test_numeric_n(q) select 999999999999999999999999999999999999999 + rownum;
insert into test_numeric_n(r) select 9999999999999999999999999999999999999999 + rownum;
insert into test_numeric_n(s) select 99999999999999999999999999999999999999999 + rownum;
insert into test_numeric_n(t) select 999999999999999999999999999999999999999999 + rownum;
select * from test_numeric_n order by 1;

drop table test_tbl;
drop table test_int;
drop table test_short;
drop table test_bigint;
drop table test_float;
drop table test_float_n;
drop table test_double;
drop table test_numeric;
drop table test_numeric_n;
