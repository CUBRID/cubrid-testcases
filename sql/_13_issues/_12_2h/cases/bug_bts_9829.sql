drop table if exists bts;
create table bts(a int auto_increment, b string);
create index idx_1 on bts(a, b);
insert into bts values (1, rpad('a', 10));
insert into bts(b) select rpad('a', 10) from db_class a, db_class b, db_class c limit 1800;
delete from bts where a=1790;
insert into bts(a, b) select 1791, 'a' from db_class a, db_class b, db_class c limit 1500;
insert into bts values(1790, rpad('a', 1000));
drop table bts;