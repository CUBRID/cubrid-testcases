create table t1 (c1 CHARACTER VARYING(20) NOT NULL,
c2 CHARACTER VARYING(20),
c3 CHARACTER VARYING(150) NOT NULL,
s SMALLINT);
alter table t1 add index i_t1_c2_s (c2, s);
alter table t1 add constraint primary key (c1);
select c1, c2 ,connect_by_iscycle from t1 start with c2='ROOT' connect by nocycle prior c1=c2 order by c1;
drop table t1;