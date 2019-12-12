
--+ holdcas on;
drop table if exists t;

set system parameters 'er_btree_debug=48';

create table t (s char(1000) collate utf8_en_ci,a int auto_increment);
create index i_t_s_desc on t(s desc);

insert into t(s) values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'aaaa');
insert into t(s) values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'baaa');
insert into t(s) values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'caaa');
insert into t(s) values (repeat (chr( conv( 'F0908083 ', 16, 10) using utf8), 980) + 'caaa');
insert into t(s)  values (repeat (chr( conv( 'F0908083 ', 16, 10) using utf8), 980) + 'Caaa');
insert into t(s)  values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'Caaa');

select substring(s,981) ,a from t where substring(s,981,1)='c' order by 2 ;

drop table if exists t;


create table t (s char(1000) collate utf8_en_cs);
create index i_t_s_desc on t(s desc);

insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'aaaa');
insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'baaa');
insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'caaa');
insert into t values (repeat (chr( conv( 'F0908083 ', 16, 10) using utf8), 980) + 'caaa');
insert into t values (repeat (chr( conv( 'F0908083 ', 16, 10) using utf8), 980) + 'Caaa');
insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'Caaa');

select substring(s,981) from t where substring(s,981,1)='c';
drop t;
create table t (s char(1000) collate utf8_en_ci);
create index i_t_s_desc on t(s desc);

insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'aaaa');
insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'baaa');
insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'caaa');
insert into t values (repeat (chr( conv( 'F0908083 ', 16, 10) using utf8), 980) + 'caaa');
insert into t values (repeat (chr( conv( 'F0908083 ', 16, 10) using utf8), 980) + 'Caaa');
insert into t values (repeat (chr( conv( 'F0908082 ', 16, 10) using utf8), 980) + 'Caaa');
drop t;

set system parameters 'er_btree_debug=0';

--+ holdcas off;
commit;
