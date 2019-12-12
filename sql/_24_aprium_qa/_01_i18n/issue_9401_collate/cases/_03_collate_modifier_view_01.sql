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


create view v as select s1 collate utf8_ko_cs as s1,s2 as s2 from t where substr(s2,2,3) ='kor';
create view v2 as select (''||s1||s2) collate utf8_ko_cs as s1 from t;
select * from v order by 1;
select * from v2 order by s1 collate utf8_ko_cs;

alter table t alter column s1 string collate utf8_ko_cs;
show full columns from v;
show full columns from v2;
select * from t order by 1;
select * from v order by 1;
select * from v2 order by 1;

drop t;
drop v;
drop v2;

set names iso88591;
commit;
--+ holdcas off;
