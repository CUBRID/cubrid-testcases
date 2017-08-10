create table liketbl ( a varchar(255));
insert into liketbl values('a');
insert into liketbl values('1a');
insert into liketbl values('%_ak%aaa_');
insert into liketbl values('aaakks');
select * from liketbl where a like '%_a';
select * from liketbl where a like '\%\_a_\%%\_' escape '\';
select * from liketbl where a like '%_\%kkk' escape '\';
select * from liketbl where a like '%kkk' escape '\';
select * from liketbl where a like '%kff' escape '\';
drop liketbl;

create class a (x integer, y integer, z integer);
create class b (x integer, y integer, z integer);

insert into a values(1, 2, 3);
insert into b values(1, 2, 3);

(select x from a order by x, y, z)
union (select x from b order by x, y, z);


(select x from a order by x, y, z for orderby_num() < 5)
union (select x from b order by x, y, z for orderby_num() < 5);

create index a_idx on a(x);
select x from a where x = 1 using index a_idx(+) order by x for orderby_num() < 5;

select 1 from db_root where (select {1} from db_root) = {1};
select 1 from db_root where (select {1} from db_root) = set(select 1 from db_root);
drop a;
drop b;

select chr(cast(48 as short)) from db_root;
select chr(cast(48 as bigint)) from db_root;
select chr(cast(48 as float)) from db_root;
select chr(cast(48 as double)) from db_root;
select chr(cast(48 as numeric)) from db_root;
select chr(cast(48 as monetary)) from db_root;

select 1 from db_root
where sysdatetime = to_datetime(to_char(sysdatetime, 'YYYY/DD/MM DAY hh24:MI:ss.ff'), 'YYYY/DD/MM DAY hh24:MI:ss.ff'); 
select 1 from db_root
where sysdatetime = to_datetime(to_char(sysdatetime, '"str" YY DD MONTH DY hh24:MI:ss.ff'), '"str" YY DD MONTH DY hh24:MI:ss.ff'); 
select 1 from db_root
where sysdatetime = to_datetime(to_char(sysdatetime, 'YY DD MONTH D hh12 MI ss ff p.m.'), 'YY DD MONTH D hh12 MI ss ff p.m.');

create table iscantbl (a int, b int, c int);
create index idx1 on iscantbl (a, b desc);
insert into iscantbl values (1, 1, 1);
insert into iscantbl values (1, 1, 2);
insert into iscantbl values (1, 2, 1);
insert into iscantbl values (1, 2, 2);

select * from iscantbl where a = 1 and b = 1 using index idx1(+) order by a, b desc for orderby_num () = 1;

create table sorttbl (a char(10000), b int);
insert into sorttbl values ('1', 1);
insert into sorttbl values ('2', 2);
insert into sorttbl values ('3', 3);

select a, b from sorttbl order by a desc for orderby_num() < 10;
select a, b, orderby_num() from sorttbl order by a desc for orderby_num() < 10;
select orderby_num() , orderby_num() from sorttbl order by b;

drop iscantbl;
drop sorttbl;

