drop table if exists t;
create table t(a char(200) primary key,b varchar,c smallint,d int,e bigint,f date,g time,h timestamp,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar primary key,c smallint,d int,e bigint,f date,g time,h timestamp,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint primary key,d int,e bigint,f date,g time,h timestamp,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int primary key,e bigint,f date,g time,h timestamp,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint primary key,f date,g time,h timestamp,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time primary key,h timestamp,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp primary key,i datetime) partition by range(a)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime primary key) partition by range(b)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime primary key) partition by range(to_char(c))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ,primary key (c)) partition by range(to_char(c))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime primary key) partition by range(to_char(d))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ,primary key (d)) partition by range(to_char(d))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
insert into t select rownum,rownum,rownum,rownum,rownum,'2008-12-1','12:12:12','2008-12-1 12:12:12','2008-12-1 12:12:55' from db_root connect by level<10;
create unique index udex1 on t(a);
create unique index udex2 on t(b);
create unique index udex3 on t(c);
create unique index udex4 on t(d);
create unique index udex5 on t(e);
create unique index udex6 on t(f);
create unique index udex7 on t(g);
create unique index udex8 on t(h);
create unique index udex9 on t(i);
create unique index udex10 on t(a,b,c,d,e,f,g,h,i);
create unique index udex11 on t(a,b,c,d,e,f,g,h);
create unique index udex12 on t(a,b,c,d,e,f,g);
create unique index udex13 on t(a,b,c,d,e,f);
create unique index udex14 on t(a,b,c,d,e);
create unique index udex15 on t(a,b,c,d);
create unique index udex16 on t(a,b,c);
create unique index udex17 on t(a,b);
create unique index udex18 on t(b,c,d,e,f,g,h,i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;
show index in t__p__p1;
show index in t__p__p2;
alter table t change d d varchar;
insert into t select rownum,rownum,rownum,'ff',rownum,'2008-12-1','12:12:12','2008-12-1 12:12:12','2008-12-1 12:12:55' from db_root connect by level<13;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(b)
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
insert into t select rownum,rownum,rownum,rownum,rownum,'2008-12-1','12:12:12','2008-12-1 12:12:12','2008-12-1 12:12:55' from db_root connect by level<10;
create unique index udex1 on t(a);
create unique index udex2 on t(b);
create unique index udex3 on t(c);
create unique index udex4 on t(d);
create unique index udex5 on t(e);
create unique index udex6 on t(f);
create unique index udex7 on t(g);
create unique index udex8 on t(h);
create unique index udex9 on t(i);
create unique index udex10 on t(a,b,c,d,e,f,g,h,i);
create unique index udex11 on t(a,b,c,d,e,f,g,h);
create unique index udex12 on t(a,b,c,d,e,f,g);
create unique index udex13 on t(a,b,c,d,e,f);
create unique index udex14 on t(a,b,c,d,e);
create unique index udex15 on t(a,b,c,d);
create unique index udex16 on t(a,b,c);
create unique index udex17 on t(a,b);
create unique index udex18 on t(b,c,d,e,f,g,h,i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;
show index in t__p__p1;
show index in t__p__p2;
alter table t change d d varchar;
insert into t select 'a'||rownum,'ff'||rownum,rownum+20,rownum,rownum,'2008-12-1','12:12:12','2008-12-1 12:12:12','2008-12-1 12:12:55' from db_root connect by level<13;
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;
show index in t__p__p1;
show index in t__p__p2;
drop table t;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(i)
(
partition p0 values less than ('2008-12-12 12:12:12'),
partition p1 values less than ('2010-12-12 12:12:12'),
partition p2 values less than ('2012-12-12 12:12:12')
);
insert into t select rownum,rownum,rownum,rownum,rownum,'2008-12-1','12:12:12','2008-12-1 12:12:12','2008-12-1 12:12:55' from db_root connect by level<10;
create unique index udex1 on t(a);
create unique index udex2 on t(b);
create unique index udex3 on t(c);
create unique index udex4 on t(d);
create unique index udex5 on t(e);
create unique index udex6 on t(f);
create unique index udex7 on t(g);
create unique index udex8 on t(h);
create unique index udex9 on t(i);
create unique index udex10 on t(a,b,c,d,e,f,g,h,i);
create unique index udex11 on t(a,b,c,d,e,f,g,h);
create unique index udex12 on t(a,b,c,d,e,f,g);
create unique index udex13 on t(a,b,c,d,e,f);
create unique index udex14 on t(a,b,c,d,e);
create unique index udex15 on t(a,b,c,d);
create unique index udex16 on t(a,b,c);
create unique index udex17 on t(a,b);
create unique index udex18 on t(b,c,d,e,f,g,h,i);
alter table t add constraint pk_a_b_c_d_e_f_g_h_i primary key(a,b,c,d,e,f,g,h,i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;
show index in t__p__p1;
show index in t__p__p2;
alter table t change d d varchar;
insert into t select rownum,rownum,rownum,'ff',rownum,'2009-12-1','12:12:12','2009-12-1 12:12:12','2009-12-1 12:12:55' from db_root connect by level<13;
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;
show index in t__p__p1;
show index in t__p__p2;
alter table t change d d varchar;
insert into t select rownum,rownum,rownum,'ff',rownum,'2011-12-1','12:12:12','2011-12-1 12:12:12','2011-12-1 12:12:55' from db_root connect by level<21;
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;
show index in t__p__p1;
show index in t__p__p2;
drop table t;
