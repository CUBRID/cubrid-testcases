set names utf8;

drop table if exists dim;
drop table if exists fact;

create table dim(s string collate utf8_en_ci primary key);
create table fact(s string collate utf8_en_cs);
alter table fact add constraint foreign key(s) references dim(s);
alter table fact change column s s string collate utf8_en_ci;
alter table fact add constraint foreign key(s) references dim(s);
drop fact,dim;

create table dim(s string collate iso88591_en_ci primary key);
create table fact(s string) collate iso88591_en_cs partition by range(s) (partition p0 values less than(_iso88591'金色'),partition p1 values less than maxvalue);
alter table fact add constraint foreign key(s) references dim(s);
drop fact,dim;

create table dim(s string primary key) collate utf8_ko_cs;
create table fact(s string) collate utf8_ko_cs_uca;
alter table fact add constraint foreign key(s) references dim(s);
alter table fact collate utf8_de_exp;
alter table fact add column s2 string;
alter table fact add constraint foreign key(s2) references dim(s);
alter table fact collate utf8_ko_cs;
alter table fact add column s3 varchar(100);
alter table fact add constraint foreign key(s3) references dim(s);
insert into fact(s3) values('金'),('납');
insert into dim values('金'),('납');
insert into fact(s3) values('金'),('납');
insert into fact select * from fact;
select distinct dim.s from dim left join fact on dim.s=fact.s3 where dim.s>'金';

drop fact,dim;

create table dim(s string collate iso88591_en_ci primary key);
create table fact(s string collate utf8_en_cs);
alter table fact add constraint foreign key(s) references dim;

drop fact,dim;

set names iso88591;
