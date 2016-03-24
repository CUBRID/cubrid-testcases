create table t1(id int primary key auto_increment, a varchar(2) collate iso88591_en_cs, b int, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select if(mod(rownum,2)=0, 'Y', 'y'), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values ('B', null, null, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values ('b', null, null, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values ('B', null, null, null, 10, 11, 11, 11);
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'y' collate iso88591_en_cs group by a collate iso88591_en_ci;

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'Y' collate iso88591_en_cs group by a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'Y' collate iso88591_en_cs group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ upper(a) from t1 where a=_iso88591'Y' collate iso88591_en_ci group by a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'Y' collate iso88591_en_ci group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ upper(a) from t1 where a=_iso88591'y' collate iso88591_en_cs group by a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'y' collate iso88591_en_cs group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ upper(a) from t1 where a=_iso88591'y' collate iso88591_en_ci group by a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'y' collate iso88591_en_ci group by a collate iso88591_en_cs;

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a='y' group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a='Y' group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_iso88591'Y' group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_utf8'Y' group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a=_euckr'Y' group by a collate iso88591_en_cs;

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a='Y' group by a collate iso88591_en_cs;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a;
--@queryplan
select /*+ recompile INDEX_LS */ upper(a) from t1 where c>0 group by a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where c>0 group by a collate iso88591_en_cs;

drop table t1;

