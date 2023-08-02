-- This test case verifies CBRD-24541 issue.
-- Core dump occurs when 'EXISTS' operation or 'count stop' is used for index scan of partitioned table.

drop table if exists ta, tb;
drop table if exists tb_stats_login_new;

create table ta(a int, b char(10) default 'abc');
insert into ta(a, b) values(1, 'a');
insert into ta(a, b) values(2, 'b');
create table tb(a int, b char(10) default 'abc', primary key(a)) partition by hash(a) partitions 5;
insert into tb(a,b) values (1, 'e');
select ta.a, ta.b from ta ta where exists (select b from tb where tb.a = ta.a); 

drop table if exists tb, ta;
create table ta(a int, b char(10) default 'abc');
insert into ta(a, b) values(1, 'a');
insert into ta(a, b) values(2, 'b');
create table tb(a int, b char(10) default 'abc') partition by hash(a) partitions 5;
create index idx1 on tb(a);
insert into tb(a,b) values (1, 'e');
select ta.a, ta.b from ta ta where exists (select b from tb where tb.a = ta.a limit 1); 

--RND-1889
CREATE TABLE [tb_stats_login_new] ([id] CHARACTER VARYING(500) NOT NULL, [servername] CHARACTER VARYING(50), [userid] CHARACTER VARYING(120) NOT NULL, [logonid] CHARACTER VARYING(50) NOT NULL, [userip] CHARACTER VARYING(50), [authtype] CHARACTER(4), [providerdomain] CHARACTER VARYING(100) NOT NULL, [sitedomain] CHARACTER VARYING(100), [whenauth] DATETIME NOT NULL, [whenauth_hour] BIGINT, [ex_schl_cd] CHARACTER VARYING(50), [ex_region] CHARACTER VARYING(120), [ex_type] CHARACTER(2), [ex_schgrade] CHARACTER VARYING(50), [ex_sclyy] NUMERIC(3,0), [whenauth_view] DATETIME, [browser] CHARACTER VARYING(50), [year] CHARACTER VARYING(10), [schoolname] CHARACTER VARYING(120), [ex_eduofficecode] CHARACTER VARYING(10), [ex_eduofficename] CHARACTER VARYING(120), [ex_addr] CHARACTER VARYING(256), [ex_schgrade_code] CHARACTER(2), [endschst] CHARACTER VARYING(40), [wireless] CHARACTER VARYING(10),  CONSTRAINT [pk_tb_stats_login_new_id_whenauth] PRIMARY KEY  ([id], [whenauth]),  INDEX [idx_tb_stats_login_new_01] ([ex_type], [whenauth], [ex_schl_cd]),  INDEX [i_tb_stats_login_new_servername_whenauth] ([servername], [userid], [whenauth]),  INDEX [i_tb_stats_login_new_whenauth_ex_schl_cd] ([whenauth], [ex_schl_cd]),  INDEX [idx_tb_stats_login_new_02] ([whenauth], [ex_type], [ex_sclyy]),  INDEX [idx_tb_stats_login_new_03] ([userid], [whenauth])) REUSE_OID, COLLATE utf8_bin PARTITION BY RANGE ( year([whenauth]))  (PARTITION [p_2015] VALUES LESS THAN (2016), PARTITION [p_2016] VALUES LESS THAN (2017), PARTITION [p_2017] VALUES LESS THAN (2018), PARTITION [p_2018] VALUES LESS THAN (2019), PARTITION [p_2019] VALUES LESS THAN (2020), PARTITION [p_2020] VALUES LESS THAN (2021), PARTITION [p_2021] VALUES LESS THAN (2022), PARTITION [p_2022] VALUES LESS THAN (2023), PARTITION [p_2023] VALUES LESS THAN (2024), PARTITION [p_2024] VALUES LESS THAN (2025), PARTITION [p_2025] VALUES LESS THAN (2026), PARTITION [p_2026] VALUES LESS THAN (2027), PARTITION [p_2027] VALUES LESS THAN (2028), PARTITION [p_2028] VALUES LESS THAN (2029), PARTITION [p_2029] VALUES LESS THAN (2030), PARTITION [last_one] VALUES LESS THAN MAXVALUE);

insert into tb_stats_login_new values ('id1', 'name', 'user1', 'log1', '1.1.1.1', 'A', 'domain', 'site', '12:00:00.000 AM 10/31/2016', 13, 'cd1', 'region', 'B', 'grade', 123.123, '12:00:00.000 AM 10/31/2017', 'browger', '2023', 'ABCschool', 'offcode', 'offname', 'addr', 'C', 'endschst', 'wireless'), ('id2', 'name', 'user1', 'log1', '1.1.1.1', 'A', 'domain', 'site', '12:00:00.000 AM 10/31/2016', 13, 'cd1', 'region', 'B', 'grade', 123.123, '12:00:00.000 AM 10/31/2017', 'browger', '2023', 'ABCschool', 'offcode', 'offname', 'addr', 'C', 'endschst', 'wireless'), ('id3', 'name', 'user1', 'log1', '1.1.1.1', 'A', 'domain', 'site', '12:00:00.000 AM 10/31/2016', 13, 'cd1', 'region', 'B', 'grade', 123.123, '12:00:00.000 AM 10/31/2017', 'browger', '2023', 'ABCschool', 'offcode', 'offname', 'addr', 'C', 'endschst', 'wireless');

select 1 from tb_stats_login_new where servername = 'name' limit 2;

drop table if exists ta, tb;
drop table if exists tb_stats_login_new;
