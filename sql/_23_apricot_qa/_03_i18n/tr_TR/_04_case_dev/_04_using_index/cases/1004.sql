--+ holdcas on;
set names utf8;
--mixdey ; data inserted after index is created 
create class foo (i integer,s char(5)  collate utf8_tr_cs,j integer,t varchar(5)  collate utf8_tr_cs,x char(4)  collate utf8_tr_cs );
create unique index foo_udx on foo (i, s, j, t);
create index int_idx on foo (i, j);
insert into foo values(101, 'İzğüı', 100001, 'aŞüke', 'açğı');
insert into foo values(102, 'İzğüe', 100002, 'bŞükd', 'bçgı');
insert into foo values(103, 'İzgüf', 100003, 'cŞükc', 'çgı');
insert into foo values(104, 'İzğüg', 100004, 'dŞükb', 'çgı');
insert into foo values(105, 'İzguh', 100005, 'eSuka', 'çgı');

select * from foo where i = 101 and j = 100001 order by i;

select * from foo where i = 101 and j = 100001 using index foo_udx order by j;


select * from foo where s = 'İzğüe' and x = 'bçgı' order by s;

select * from foo where s = 'İzğüe' and x = 'bçgı' using index foo_udx order by x;

select * from foo where s = 'İzğüe' and t = 'bŞükd' order by x;

select * from foo where t = 'dŞükb' or x = 'çgı' order by s;

select * from foo where t = 'dŞükb' or x = 'çgı' using index foo_udx(+) order by t;

select * from foo where i = 101 or t = 'dŞükb' using index int_idx, foo_udx  order by i;

select * from foo where i = 101 or t = 'dŞükb' using index int_idx(+), foo_udx(+)  order by x;

select * from foo where i = 101 or t = 'dŞükb' using index none  order by t;

drop class foo;
set names iso88591;
commit;
--+ holdcas off;

