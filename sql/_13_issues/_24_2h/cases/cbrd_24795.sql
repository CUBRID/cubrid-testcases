-- This test case verifies CBRD-24795 issue.
/* ----------------------------------------
 *  1. predicate:  1 = abs (ta.b)                               key range: ( abs(ta.b)= ?:0 )
 *  2. predicate:  1 = -abs (ta.b)                              key range: ( abs(ta.b)=-1)
 *  3. predicate:  1 = -(-abs (ta.b))                           key range: ( abs(ta.b)= ?:0 )
 *  4. predicate: -1 = -abs (ta.b)                              key range: ( abs(ta.b)=--1)
 *  5. predicate: -1 = -(-abs (ta.b))                           key range: ( abs(ta.b)= ?:0 )
 *  6. predicate:  1 > abs (tb.b)                               key range: ( abs(ta.b)< ?:0 )
 *  7. predicate:  1 > -abs (ta.b)                              key range: ( abs(ta.b)>-1)
 *  8. predicate: ta.b = abs (tb.b) and ta.c = abs (tb.b)       key range: ta.b= abs(tb.b)
 *  9. predicate: ta.b <= abs (tb.b) and ta.c > abs (tb.b)      key range: NULL
 *                                                               - data filter: (ta.b<= abs(tb.b)) and (ta.c> abs(tb.b))
 * 10. predicate: abs (tb.b) >= ta.b and ta.c > abs (tb.b)      key range: ( abs(tb.b)>=ta.b)
 *                                                               - data filter: (ta.c> abs(tb.b))
 * 11. predicate: abs (tb.b) >= ta.b and abs (tb.b) < ta.c      key range: ( abs(tb.b)>=ta.b and  abs(tb.b)<ta.c)
 * 12. predicate: ta.b <= tb.b and ta.c > tb.b                  key range: NULL
 *                                                               - key filter: (ta.b<=tb.b), key filter: (ta.c>tb.b)
 * 13. predicate: tb.b >= ta.b and tb.b < ta.c                  key range: (tb.b>=ta.b and tb.b<ta.c)
 * 14. predicate: (ta.b = abs (tb.b) or ta.c = abs (tb.b))      key range: (( abs(tb.b)=ta.b) or ( abs(tb.b)=ta.c))
 * 15. predicate: (ta.b <= abs (tb.b) or ta.c > abs (tb.b))     key range: (( abs(tb.b)>=ta.b) or ( abs(tb.b)<ta.c))
 * 16. predicate: (ta.b <= -abs (tb.b) or ta.c > -abs (tb.b))   key range: NULL
 *                                                               - data filter: ((ta.b<=- abs(tb.b)) or (ta.c>- abs(tb.b)))
 * 17. predicate: (ta.b <= -abs (tb.b) or ta.c > abs (tb.b))    key range: NULL
 *                                                               - data filter: ((ta.b<=- abs(tb.b)) or ( abs(tb.b)<ta.c))
 * 18. predicate: (-ta.b <= -abs (tb.b) or ta.c > abs (tb.b))   key range: (( abs(tb.b)<=ta.b) or ( abs(tb.b)<ta.c))
 * 19. predicate: (ta.b >= -tb.b or ta.c > -tb.b)               key range: NULL
 *                                                               - key filter: ((ta.b<=-tb.b) or (ta.c>-tb.b))
 * 20. predicate: (ta.b >= -tb.b or ta.c > tb.b)                key range: NULL
 *                                                               - key filter: ((ta.b<=-tb.b) or (tb.b<ta.c))
 * 21. predicate: (ta.b = abs (tb.b) or abs (tb.b) = ta.c or ta.d = abs (tb.b))
 *                                                              key range: (( abs(tb.b)=ta.b) or ( abs(tb.b)=ta.c) or ( abs(tb.b)=ta.d))
 * 22. predicate: 1 <= abs (ta.b) and 10 > abs (ta.b) and abs (tb.b) >= 9 and abs (tb.b) < 19
 *                                                              key range: ( abs(ta.b)>= ?:0  and  abs(ta.b)< ?:1 )
 *                                                              key range: ( abs(tb.b)>= ?:2  and  abs(tb.b)< ?:3 )
 * 23. predicate: abs (ta.b) between 1 and 1000 and 999 <= abs (ta.b)
 *                                                              key range: ( abs(ta.b)>= ?:0  and  abs(ta.b)<= ?:1 )
 * 24. predicate: -abs (ta.b) between -1000 and -1 and 999 <= abs (ta.b)
 *                                                              key range: ( abs(ta.b)>=--1 and  abs(ta.b)<=--1000)
 *                                                               - data filter: ( abs(ta.b)>= ?:0 )
 * 25. predicate: -ta.b between -1000 and -1 and 999 <= ta.b
 *                                                              key range: (ta.b>=--1 and ta.b<=--1000)
 *                                                               - key filter: (ta.b>= ?:0 )
 * 26. predicate: length (ta.b) > 5 and length (ta.b) <= 6      key range:  char_length( cast(ta.b as varchar))<=6
 * 27. predicate: length (cast (ta.b as varchar)) > 5 and length (cast (ta.b as varchar)) <= 6
 *                                                              key range: ( char_length( cast(ta.b as varchar))> ?:0  and  char_length( cast(ta.b as varchar))<= ?:1 )
 * 28. predicate: ca = 'Y' and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') >= '2023-04-26 00:00:00' and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') <= '2023-04-27 23:59:59'
 *                                                              key range: [dba.tblb].ca= ?:2
 *                                                              key range: ( to_char([dba.tblb].cb, 'YYYY-MM-DD HH24:MI:SS')>= ?:0  and  to_char([dba.tblb].cb, 'YYYY-MM-DD HH24:MI:SS')<= ?:1 )
 * 29. predicate: to_char (cb, 'YYYY-MM-DD HH24:MI:SS') >= '2023-04-26 00:00:00' and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') <= '2023-04-27 23:59:59'
 *                                                              key range: ( to_char([dba.tblb].cb, 'YYYY-MM-DD HH24:MI:SS')>= ?:0  and  to_char([dba.tblb].cb, 'YYYY-MM-DD HH24:MI:SS')<= ?:1 )
 * ---------------------------------------- */


drop table if exists tbla;
create table tbla (a int, b int, c int, d int, e int);
insert into tbla select rownum, rownum, rownum, rownum, rownum from db_class a, db_class b, db_class c, db_class d, db_class e limit 10000;
insert into tbla select -rownum, -rownum, -rownum, -rownum, -rownum from db_class a, db_class b, db_class c, db_class d, db_class e limit 10000;
create index idx_tbla_a_b on tbla (a, b);
create index idx_tbla_b_a on tbla (b, a);
create index idx_tbla_a_abs_b on tbla (a, abs (b));
create index idx_tbla_abs_b_a on tbla (abs (b), a);
create index idx_tbla_length_b on tbla (length (b));

drop table if exists tblb;
create table tblb (ca char(1), cb datetime);
insert into tblb select 'Y', to_datetime ('2023-01-01') + (rownum - 1) * 3600 * 1000 from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;
insert into tblb select 'N', to_datetime ('2023-01-01') + (rownum - 1) * 3600 * 1000 from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;
create index i_a on tblb (ca, cb);
create index i_b on tblb (ca, to_char (cb, 'YYYY-MM-DD HH24:MI:SS'));
create index i_c on tblb (to_char (cb, 'YYYY-MM-DD HH24:MI:SS'));

update statistics on tbla, tblb with fullscan;


set trace on;

evaluate 'test case 1';
select /*+ recompile */ ta.*
from tbla ta
where 1 = abs (ta.b)
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 2';
select /*+ recompile */ ta.*
from tbla ta
where 1 = -abs (ta.b)
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 3';
select /*+ recompile */ ta.*
from tbla ta
where 1 = -(-abs (ta.b))
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 4';
select /*+ recompile */ ta.*
from tbla ta
where -1 = -abs (ta.b)
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 5';
select /*+ recompile */ ta.*
from tbla ta
where -1 = -(-abs (ta.b))
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 6';
select /*+ recompile */ ta.*
from tbla ta
where 1 > abs (ta.b)
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 7';
select /*+ recompile */ ta.*
from tbla ta
where 1 > -abs (ta.b)
using index ta.idx_tbla_abs_b_a
limit 1;
show trace;

evaluate 'test case 8';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where ta.b = abs (tb.b) and ta.c = abs (tb.b)
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 9';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where ta.b <= abs (tb.b) and ta.c > abs (tb.b)
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 10';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where abs (tb.b) >= ta.b and ta.c > abs (tb.b)
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 11';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where abs (tb.b) >= ta.b and abs (tb.b) < ta.c
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 12';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where ta.b <= tb.b and ta.c > tb.b
and ta.a = tb.a
using index tb.idx_tbla_a_b
limit 1;
show trace;

evaluate 'test case 13';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where tb.b >= ta.b and tb.b < ta.c
and ta.a = tb.a
using index tb.idx_tbla_a_b
limit 1;
show trace;

evaluate 'test case 14 (Changed after CBRD-25116)';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b = abs (tb.b) or ta.c = abs (tb.b))
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 15 (Changed after CBRD-25116)';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b <= abs (tb.b) or ta.c > abs (tb.b))
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 16';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b <= -abs (tb.b) or ta.c > -abs (tb.b))
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 17';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b <= -abs (tb.b) or ta.c > abs (tb.b))
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
order by ta.a
limit 1;
show trace;

evaluate 'test case 18 (Changed after CBRD-25116)';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (-ta.b <= -abs (tb.b) or ta.c > abs (tb.b))
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 19';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b <= -tb.b or ta.c > -tb.b)
and ta.a = tb.a
using index tb.idx_tbla_a_b
limit 1;
show trace;

evaluate 'test case 20 (Changed after CBRD-25116)';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b <= -tb.b or ta.c > tb.b)
and ta.a = tb.a
using index tb.idx_tbla_a_b
order by ta.a
limit 1;
show trace;

evaluate 'test case 21 (Changed after CBRD-25116)';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where (ta.b = abs (tb.b) or abs (tb.b) = ta.c or ta.d = abs (tb.b))
and ta.a = tb.a
using index tb.idx_tbla_a_abs_b
limit 1;
show trace;

evaluate 'test case 22';
select /*+ recompile ordered */ ta.*
from tbla ta, tbla tb
where 1 <= abs (ta.b) and 10 > abs (ta.b) and abs (tb.b) >= 9 and abs (tb.b) < 19
and ta.a = tb.a
using index ta.idx_tbla_abs_b_a, tb.idx_tbla_a_abs_b;
show trace;

evaluate 'test case 23';
select /*+ recompile */ ta.*
from tbla ta
where abs (ta.b) between 1 and 1000 and 999 <= abs (ta.b)
using index ta.idx_tbla_abs_b_a;
show trace;

evaluate 'test case 24 (Changed after CBRD-25116)';
select /*+ recompile */ ta.*
from tbla ta
where -abs (ta.b) between -1000 and -1 and 999 <= abs (ta.b)
using index ta.idx_tbla_abs_b_a;
show trace;

evaluate 'test case 25';
select /*+ recompile */ ta.*
from tbla ta
where -ta.b between -1000 and -1 and 999 <= ta.b
using index ta.idx_tbla_b_a;
show trace;

evaluate 'test case 26';
select /*+ recompile */ ta.*
from tbla ta
where length (ta.b) > 5 and length (ta.b) <= 6
using index ta.idx_tbla_length_b(+);
show trace;

evaluate 'test case 27';
select /*+ recompile */ ta.*
from tbla ta
where length (cast (ta.b as varchar)) > 5 and length (cast (ta.b as varchar)) <= 6
using index ta.idx_tbla_length_b(+);
show trace;

evaluate 'test case 28';
select /*+ recompile */ count(ca)
from tblb
where 1=1
and ca = 'Y'
and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') >= '2023-04-26 00:00:00'
and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') <= '2023-04-27 23:59:59';
show trace;

evaluate 'test case 29';
select /*+ recompile */ count(ca)
from tblb
where 1=1
and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') >= '2023-04-26 00:00:00'
and to_char (cb, 'YYYY-MM-DD HH24:MI:SS') <= '2023-04-27 23:59:59';
show trace;

drop table tbla;
drop table tblb;
