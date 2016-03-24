--+ holdcas on;
set names utf8;
--mixdey ; range search
create class foo (i integer,s char(5)  collate utf8_tr_cs,j integer,t varchar(5)  collate utf8_tr_cs,x char(4)  collate utf8_tr_cs );
insert into foo values(101, 'İzğüı', 100001, 'aŞüke', 'açğı');
insert into foo values(101, 'İzğüe', 100002, 'bŞükd', 'bçgı');
insert into foo values(101, 'İzgüf', 100003, 'cŞükc', 'çgı');
insert into foo values(101, 'İzğüg', 100004, 'dŞükb', 'çgı');
insert into foo values(101, 'İzguh', 100005, 'eSuka', 'çgı');
create unique index foo_udx on foo (i, s, j, t);
create index int_idx on foo (i, j);

insert into foo values(102, 'İzğüı', 100001, 'aŞüke', 'açğı');
insert into foo values(102, 'İzğüe', 100002, 'bŞükd', 'bçgı');
insert into foo values(102, 'İzgüf', 100003, 'cŞükc', 'çgı');
insert into foo values(102, 'İzğüg', 100004, 'dŞükb', 'çgı');
insert into foo values(102, 'İzguh', 100005, 'eSuka', 'çgı');

select * from foo where i = 101 and s >= 'İzgüf' and s <= 'İzğüi' order by s;

select * from foo where i = 102 and s IN { 'İzğüı' , 'İzgüf'}  and x between 'açğı' and 'çgh'  order by x;


drop class foo;
set names iso88591;
commit;
--+ holdcas off;

