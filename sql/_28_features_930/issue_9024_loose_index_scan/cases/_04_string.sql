create table t1(id int primary key auto_increment, a varchar(2) collate iso88591_en_cs, b varchar(2) collate iso88591_en_ci, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select if(mod(rownum,2)=0, 'Y', 'y'), if(mod(rownum,2)=0, 'y', 'Y'),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, 99, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values ('B', null, 99, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values ('b', null, 99, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values ('B', null, 88, null, 10, 11, 11, 11);
create unique index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a;
--@queryplan
select /*+ recompile INDEX_LS */ b, max(a),min(a) from t1 where c>=0 group by b;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a having max(b collate iso88591_en_ci)='a';
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a having max(b collate iso88591_en_cs)='a';
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a having max(b collate iso88591_en_cs)='A';
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a having max(b collate iso88591_en_ci)=a;
--@queryplan
select /*+ recompile INDEX_LS */ a,max(b collate iso88591_en_cs), min(b collate iso88591_en_cs) from t1 where h%2=0 group by a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ a,max(b collate iso88591_en_cs), min(b collate iso88591_en_cs) from t1 where c>0 group by a collate iso88591_bin;

drop table t1;

