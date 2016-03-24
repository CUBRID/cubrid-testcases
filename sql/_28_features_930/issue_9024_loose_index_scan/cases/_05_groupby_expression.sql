create table t1(id int primary key auto_increment, a varchar(2) collate iso88591_en_cs, b varchar(2) collate iso88591_en_ci, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select if(mod(rownum,2)=0, 'X', 'x'), if(mod(rownum,2)=0, 'Y', 'y'),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, 99, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values ('Z', null, 99, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values ('z', null, 99, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values ('Z', null, 88, null, 10, 11, 11, 11);
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where c>0 group by a collate iso88591_en_ci||b||c||d||e||f||g;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where c>0 group by a collate iso88591_en_ci||b||c||d||e||f||g desc;

--@queryplan
select /*+ recompile INDEX_LS */ upper(a), max(g),min(g) from t1 where c>0 group by upper(a);
--@queryplan
select /*+ recompile INDEX_LS */ upper(a), max(g),min(g) from t1 where c>0 group by upper(a) desc;
--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 where c>0 group by lower(a);
--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 where c>0 group by lower(a) desc;

set @v1=10;
--@queryplan
select /*+ recompile INDEX_LS */ max(a),max(b),max(c),max(d),max(e),max(f),max(g) from t1 where c>0 group by @v1;
--@queryplan
select /*+ recompile INDEX_LS */ min(a),min(b),min(c),min(d),min(e),min(f),min(g) from t1 where c>0 group by @v1;
--@queryplan
select /*+ recompile INDEX_LS */ min(a),min(b),min(c),min(d),min(e),min(f),min(g) from t1 where c>0 group by @v1, a desc;

--@queryplan
select /*+ recompile INDEX_LS */ min(a),min(b),min(c),min(d),min(e),min(f),min(g) from t1 where c>=0 group by (@v1:=@v1+1)%20;

--@queryplan
prepare stmt from 'select /*+ recompile INDEX_LS */ c + ? + ? ,max(g) from t1 where c>=0 group by c + ? + ?';
--@queryplan
execute stmt using 10,10,10,10;
deallocate prepare stmt;

--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 where c>0 group by lower(a) having max(c)<100;
--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 where c>0 group by lower(a) having max(c) is not null;
--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 where c>0 group by lower(a) having max(c) is null;
--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 where c>0 group by lower(a) having max(t1.c)<100;

--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 w where c>0 group by lower(w.a) having max(w.c)<100;
--@queryplan
select /*+ recompile INDEX_LS */ lower(a), max(g),min(g) from t1 w where c>0 group by last_insert_id() having max(w.c)<100;
--@queryplan
select /*+ recompile INDEX_LS */ max(b),a from t1 w where c>0 group by now(),a desc;
--@queryplan
select /*+ recompile INDEX_LS */ max(b),a from t1 w where c>0 group by now(),a collate iso88591_en_ci;
--@queryplan
select /*+ recompile INDEX_LS */ max(b),a from t1 w where c>0 group by a ||(select 'A');
--@queryplan
select /*+ recompile INDEX_LS */ a,a like 'X%' from t1 w where c>0 group by a like 'X%';
--@queryplan
select /*+ recompile INDEX_LS */ max(b),a from t1 w where c>0 group by c;

drop variable @v1;

drop table t1;
