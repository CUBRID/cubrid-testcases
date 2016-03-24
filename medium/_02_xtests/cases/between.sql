autocommit off;
create table barbar(b varchar(1));
insert into barbar values('a');
insert into barbar values('b');
insert into barbar values('c');
insert into barbar values('d');
insert into barbar values('e');
insert into barbar values('f');
insert into barbar values('g');
insert into barbar values('h');
insert into barbar values('i');
insert into barbar values('j');
insert into barbar values('k');
insert into barbar values('l');
insert into barbar values('m');
insert into barbar values('n');
insert into barbar values('o');
insert into barbar values('p');
insert into barbar values('q');
insert into barbar values('r');
insert into barbar values('s');
insert into barbar values('t');
insert into barbar values('u');
insert into barbar values('v');
insert into barbar values('w');
insert into barbar values('x');
insert into barbar values('y');
insert into barbar values('z');
create index i_barbar_b on barbar(b);
--set optimization: level 257;
--set optimization: cost 'iscan' 0;
select * from barbar 
where b between (select 'a' from db_root) and (select 'v' from db_root)
order by 1;
select * from barbar 
where b between (select 'a' from db_root) and (select 'v' from db_root) or
      b between (select 'b' from db_root) and (select 'z' from db_root)
order by 1;
select * from barbar
where b between (select 'g' from db_root) and (select 'v' from db_root)
or
b between (select 'l' from db_root) and (select 'z' from db_root)
order by 1;
rollback work;
rollback;
