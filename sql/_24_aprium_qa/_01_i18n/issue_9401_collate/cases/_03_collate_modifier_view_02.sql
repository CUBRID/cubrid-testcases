--+ holdcas on;
set names utf8;

drop table if exists t;
create table t(s1 string collate utf8_ko_cs_uca primary key,s2 string collate utf8_ko_cs) partition by range(s1) (partition p0 values less than ('간'),partition p1 values less than ('袂'),partition p2 values less than maxvalue); 
create index i on t(s2);
insert into t values
(' ',' ')                 
,('"','"')      
,('%','%')                 
,('A','Akora')                 
,('C','C')                
,('c','c')                 
,('가','佳')               
,('佳','侃')               
,('간','天kor')               
,('侃','年')               
,('金','袂ko')               
,('끽','金')               
,('납','가')               
,('年','간korean')               
,('袂','끽')               
,('天','납');
create view v as select s1 as s1,s2 as s2 from t where s1 collate utf8_ko_cs < '金' order by s1 collate utf8_ko_cs desc limit 4 offset 1;
show full columns from v;
select * from v order by 2 desc;

delete from t where s1 collate utf8_ko_cs<'金';
select * from v order by 1 desc;

drop index i on t(s2);
select * from v order by 1 desc;
insert into v values('天','天'),('가','가');
select * from t order by s1 collate utf8_ko_cs;

drop t;
drop v;

set names iso88591;
commit;
--+ holdcas off;
