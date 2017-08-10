set names utf8;

drop table if exists t;
drop table if exists dim;

create table t(i int,n1 nchar(10),n2 nchar(10)) collate utf8_ko_cs;
insert into t values(1,N'袂',N'袂'),(2,N'金',N'金'),(3,N'가',N'가'),(4,N'간',N'간');
alter table t change column n2 n2 nchar(10) collate utf8_ko_cs_uca;
create index i on t(n1,n2 desc);
show full columns from t;
select * from t order by 2;
select * from t order by 3;
update t set n1=trim(n1)||cast(n2 as nchar(10) collate utf8_ko_cs) where i<3;
select collation(n1),collation(n2) from t limit 1;
alter table t collate utf8_ko_cs_uca;
alter table t add column n3 nchar varying;
alter table t change column n3 n3 string collate utf8_de_exp;
update t set n3=n1;
create table dim(n3 nchar(10) primary key) collate utf8_ko_cs;
insert into dim select distinct n3 from t;
alter table t add constraint foreign key (n3) references dim(n3);
alter table dim change column n3 n3 nchar varying collate utf8_ko_cs_uca;
alter table t add constraint foreign key (n3) references dim(n3);
insert into t select i,n1,n2,N'金金 ' from t;
select * from dim left join t on t.n3=dim.n3 order by t.n3,t.n2,t.n1;
alter table t change column n2 n2 nchar(10) collate utf8_ko_cs;
select * from dim left join t on t.n3=dim.n3 order by t.n3,t.n2,t.n1;
drop t,dim;

set names iso88591;
