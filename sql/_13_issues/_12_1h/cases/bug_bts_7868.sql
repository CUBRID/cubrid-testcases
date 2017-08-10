drop table if exists foo;
drop table if exists table_j;
drop table if exists table_d;
drop table if exists table_g;

create table foo (obj_id int, h_id int, s_id varchar(20), g_id int, host_id int);
create table table_j (host_id int);
create table table_d (svc_no varchar(20), s_id varchar(20));
create table table_g (svr_grp_no int);

create unique index pk_foo on foo(host_id);
create unique index unique_foo on foo(obj_id);
create index index_foo_grp on foo(g_id, s_id);
create index index_foo_rep_svc on foo(s_id, h_id);

create unique index pk_table_j on table_j(host_id);

create unique index pk_table_d on table_d(svc_no);

create index index_table_g on table_g(svr_grp_no);

insert into foo values(1, 1, '2152', 1, 1);
insert into table_j values(1);
insert into table_d values('2152', 'TEST');
insert into table_g values(1);

SELECT /*+ RECOMPILE */ foo.obj_id, foo.h_id FROM foo
INNER JOIN table_j ON foo.host_id = table_j.host_id
LEFT OUTER JOIN table_d ON foo.s_id = table_d.svc_no
LEFT OUTER JOIN table_g ON foo.g_id = table_g.svr_grp_no
WHERE table_d.svc_no = foo.s_id AND foo.s_id = '2152';

drop table foo;
drop table table_j;
drop table table_d;
drop table table_g;

