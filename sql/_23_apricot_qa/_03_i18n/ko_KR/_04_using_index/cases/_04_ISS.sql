--+ holdcas on;
set names utf8;
drop table if exists a,t;
create table a (i int auto_increment);
insert into a (i) values(NULL);
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;


create table t (i varchar(255) collate utf8_ko_cs_uca, j varchar(255) collate utf8_ko_cs_uca, k varchar(255) collate utf8_ko_cs_uca, s string collate utf8_ko_cs_uca);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, '가'+cast(i as varchar collate utf8_ko_cs_uca), '가'+cast(i as varchar collate utf8_ko_cs_uca), '가'+cast(i as varchar collate utf8_ko_cs_uca) from a;
insert into t(i,j,k, s) select 1, '테'+cast(i as varchar collate utf8_ko_cs_uca), '테'+cast(i as varchar collate utf8_ko_cs_uca), '테'+cast(i as varchar collate utf8_ko_cs_uca) from a;
insert into t(i,j,k, s) select 2, '이'+cast(i as varchar collate utf8_ko_cs_uca), '이'+cast(i as varchar collate utf8_ko_cs_uca), '이'+cast(i as varchar collate utf8_ko_cs_uca) from a;

create index idx  on t(i,j,k);

update statistics on all classes;


select /*+ recompile index_ss */ i, j from t where j = '가'+'2';

select /*+ recompile index_ss */ i, j from t where j like '_2';
drop table t;

drop table a;
set names iso88591;
commit;
--+ holdcas off;
