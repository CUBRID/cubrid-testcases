drop if exists t1; 

create table t1 (i int,a varchar(10) collate iso88591_en_ci);
insert into t1 values (1,'AA'), (2,'aa');
--note: good
select t1.a from t1 t1 where (t1.a <= 'BB') order by i;
--note: good
select t1.a from t1 t1 where (t1.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

--test: fail. nothing will be returned. Expect 'aa' is returned.
select t1.a from t1 t1 where  (t1.a <= 'BB') and (t1.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <> 'BB') and (t1.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <> 'BB') and (t1.a collate iso88591_en_cs!='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <> 'BB') and (t1.a collate iso88591_en_cs<>'aa' collate iso88591_en_cs);

drop t1; 



create table t1 (i int,a char(10) collate iso88591_en_ci);
insert into t1 values (1,'AA'), (2,'aa'), (3,null);

select t1.a from t1 t1 where (t1.a <= 'BB') order by i;

select t1.a from t1 t1 where (t1.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <= 'BB') and (t1.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <> 'BB') and (t1.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <> 'BB') and (t1.a collate iso88591_en_cs!='aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a <> 'BB') and (t1.a collate iso88591_en_cs<>'aa' collate iso88591_en_cs);

select t1.a from t1 t1 where  (t1.a is null) and (t1.a collate iso88591_en_cs!='aa' collate iso88591_en_cs);

select * from t1 b where  (a is null);


create table t2 as select * from t1;

select t2.a from t2 t2 where (t2.a <= 'BB') order by t2.i;

select t2.a from t2 t2 where (t2.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t2.a from t2 t2 where  (t2.a <= 'BB') and (t2.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t2.a from t2 t2 where  (t2.a <> 'BB') and (t2.a collate iso88591_en_cs='aa' collate iso88591_en_cs);

select t2.a from t2 t2 where  (t2.a <> 'BB') and (t2.a collate iso88591_en_cs!='aa' collate iso88591_en_cs);

select t2.a from t2 t2 where  (t2.a <> 'BB') and (t2.a collate iso88591_en_cs<>'aa' collate iso88591_en_cs);

select t2.a from t2 t2 where  (t2.a is null) and (t2.a collate iso88591_en_cs!='aa' collate iso88591_en_cs);

select * from t2 b where  (a is null);

drop t2,t1; 

