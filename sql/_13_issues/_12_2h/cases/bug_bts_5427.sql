CREATE TABLE "tewffin_sju"(
"oahe_id" character varying(30),
"fish_oes" character varying(256),
"fish_aich" bigint,
"action" smallint,
"nsihmt" smallint,
"atwth" character(1),
"ip" character varying(15),
"sju_dt" timestamp
)
partition by range (sju_dt)(
     PARTITION P00 VALUES LESS THAN (timestamp '12:00:00 AM 01/01/2011'),
     PARTITION P20 VALUES LESS THAN (timestamp '12:00:00 AM 05/21/2011'),
     PARTITION P21 VALUES LESS THAN (timestamp '12:00:00 AM 05/22/2011'),
     PARTITION P22 VALUES LESS THAN (timestamp '12:00:00 AM 05/23/2011'),
     PARTITION P23 VALUES LESS THAN (timestamp '12:00:00 AM 05/24/2011')
);
CREATE  INDEX i_tewffin_sju_oahe_id_sju_dt ON "tewffin_sju"("oahe_id","sju_dt");
CREATE  INDEX i_tewffin_sju_ip_sju_dt ON "tewffin_sju"("ip","sju_dt");
CREATE  INDEX i_tewffin_sju_sju_dt ON "tewffin_sju"("sju_dt");
insert tewffin_sju values('1','aaa',456,3,3,1,'10.34.64.146','2011-05-22 00:00:00');
insert tewffin_sju values('2','aaa',456,3,3,1,'10.34.64.146','2011-01-22 00:00:00');
insert tewffin_sju values('3','aaa',456,3,3,1,'10.34.64.146','2011-05-23 00:00:00');

select /*+ recompile*/ sju_dt from tewffin_sju where sju_dt > '2011-01-01 00:00:00' and fish_oes = 'aaa' order by sju_dt desc limit 1;

create table fjj(t timestamp);
insert into fjj values('2011-01-01 00:00:00');
insert into fjj values('2011-05-01 00:00:00');
insert into fjj values('2011-06-01 00:00:00');
select /*+ recompile*/ t from fjj where t > '2011-05-01 00:00:00' order by t limit 1;
drop table tewffin_sju;
drop table fjj;
