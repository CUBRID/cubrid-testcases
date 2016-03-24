autocommit off;
create table t1(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2, db_class x3 limit 5000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, 888, null, null, null, null, null);
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile index_ls */ a from t1 where c>0 group by a desc;

drop table t1;

autocommit on;