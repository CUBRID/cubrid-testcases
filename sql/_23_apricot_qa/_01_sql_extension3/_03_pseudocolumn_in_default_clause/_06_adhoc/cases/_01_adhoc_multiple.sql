set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists ordby_nulls;
create table t1 (b char(10), c int);
insert into t1 values ('a', 1),('b', 2), ('c', 3), ('d', 4), ('e', 5);
insert into t1 select * from t1;
insert into t1 select * from t1;
insert into t1 select * from t1;
insert into t1 select * from t1;
CREATE TABLE t2(a timestamp default CURRENT_TIMESTAMP, b char(10), c int);
INSERT INTO t2(b,c) select x1.b,x1.c  from t1 x1, t1 x2;
select count(distinct a) from t2;
drop table t1;
drop table t2;	

create table t1 (a int);
insert into t1 select rownum from db_class x1, db_class x2, db_class x3, db_class x4 limit 10000;
CREATE TABLE t2(a timestamp default CURRENT_TIMESTAMP, b int, c int);
create index i_t2_a on t2(a);
INSERT INTO t2(b,c) select 1,1 from t1;
drop table t1;
drop table t2;

CREATE TABLE t2(a DATETIME default CURRENT_DATETIME, b int, c int);
create index i_t2_a on t2(a);
insert into t2 (b,c) values (1,1);
insert into t2 (c) values (2);
insert into t2 () values (null, 3,3);
insert into t2 () values (default, 4,4);
insert into t2 (a) values (default);
insert into t2 (a) values (default(a));
insert into t2 (a,b) values (default(a), 5);
insert into t2 (a,b,c) values (default(a), 6,6);
insert into t2 (a,b,c) select default(a), 7, 7 from t2 limit 1;
insert into t2 (a,b,c) select default(b), 8, 8 from t2 limit 1;
select count(*) from t2;
delete from t2;
insert into t2 (b,c) values (1,1);
update t2 set a=default(a), b =2 where c=1;
update t2 set a=default, b =3 where c=1;
update t2 set a=null, b =3 where c=1;
select count(*) from t2;
update t2 set a=default(a), b =2 where c=1;
--windows execute fast than linux ,so bellow is not stable,add code to delay the time 
drop table if exists wo;
create table wo(i int,j int);
insert into wo select rownum,rownum%10 from db_root connect by level<=10000;
drop wo;
update t2 set a=default where c=1 and a<>default(a);
update t2 set a=null, b=0 where c=1;
update t2 set a=default where c=1 and a is null;
update t2 set a=default(a) where c=1;
select count(*) from t2;
drop table t2;


CREATE TABLE t2(a varchar(20) default USER, b int, c int);
create index i_t2_a on t2(a);
replace into t2(b,c) values (1, 1);
replace into t2 values (default(a), 2,1);
replace into t2 values (default, 3,1);
select * from t2 order by 1,2,3;
drop table t2;
drop table t1;

CREATE TABLE t1(a varchar(20) default USER, b int, c int);
create index i_t1_a on t1(a);
prepare stmt from 'replace into t1(b,c) values (1, 1)';
execute stmt;
deallocate prepare stmt;
prepare stmt from 'replace into t1 values (default(a), 2,1)';
execute stmt;
deallocate prepare stmt;
prepare stmt from 'replace into t1 values (default, 3,1)';
execute stmt;
deallocate prepare stmt;
prepare stmt from 'replace into t1 values (?, 3,1)';
execute stmt using USER;
deallocate prepare stmt;
select /*+ recompile */ * from t1 where a=USER order by 1,2,3;
select /*+ recompile */ * from t1 where a=default(a) order by 1,2,3;
select /*+ recompile */ * from t1 where a=default(a)||repeat(USER,10) order by 1,2,3;
select /*+ recompile */ * from t1 where a=repeat(USER,1) order by 1,2,3;
select /*+ recompile */ * from t1 where a=repeat(USER,1) order by USER,2,3;
drop table t1;



CREATE TABLE t1(a varchar(20) default CURRENT_USER, b int, c int);
create index i_t1_a on t1(a);
prepare stmt from 'replace into t1(b,c) values (1, 1)';
execute stmt;
deallocate prepare stmt;
prepare stmt from 'replace into t1 values (default(a), 2,1)';
execute stmt;
deallocate prepare stmt;
prepare stmt from 'replace into t1 values (default, 3,1)';
execute stmt;
deallocate prepare stmt;
prepare stmt from 'replace into t1 values (?, 3,1)';
execute stmt using CURRENT_USER;
deallocate prepare stmt;
select /*+ recompile */ * from t1 where a=CURRENT_USER order by 1,2,3;
select /*+ recompile */ * from t1 where a=default(a) order by 1,2,3;
select /*+ recompile */ * from t1 where a=default(a)||repeat(CURRENT_USER,10) order by 1,2,3;
select /*+ recompile */ * from t1 where a=repeat(CURRENT_USER,1) order by 1,2,3;
select /*+ recompile */ * from t1 where a=repeat(CURRENT_USER,1) order by CURRENT_USER,2,3;
drop table t1;


create table t1;
alter table t1 add column     a1   varchar(20) default CURRENT_USER;
alter table t1 add column     a2   varchar(21) default CURRENT_USER;
alter table t1 add column    a3   varchar(22) default CURRENT_USER;
alter table t1 add column    a4   varchar(23) default CURRENT_USER;
alter table t1 add column    a5   varchar(24) default CURRENT_USER;
alter table t1 add column    a6   varchar(25) default CURRENT_USER;
alter table t1 add column    a7   varchar(26) default CURRENT_USER;
alter table t1 add column    a8   varchar(27) default CURRENT_USER;
alter table t1 add column    a9   varchar(28) default CURRENT_USER;
alter table t1 add column    a10   varchar(29) default CURRENT_USER;
alter table t1 add column    a11   varchar(30) default CURRENT_USER;
alter table t1 add column    a12   varchar(31) default CURRENT_USER;
alter table t1 add column    a13   varchar(32) default CURRENT_USER;
alter table t1 add column    a14   varchar(33) default CURRENT_USER;
alter table t1 add column    a15   varchar(34) default CURRENT_USER;
alter table t1 add column    a16   varchar(35) default CURRENT_USER;
alter table t1 add column    a17   varchar(36) default CURRENT_USER;
alter table t1 add column    a18   varchar(37) default CURRENT_USER;
alter table t1 add column    a19   varchar(38) default CURRENT_USER;
alter table t1 add column    a20   varchar(39) default CURRENT_USER;
alter table t1 add column    a21   varchar(40) default CURRENT_USER;
alter table t1 add column    a22   varchar(41) default CURRENT_USER;
alter table t1 add column    a23   varchar(42) default CURRENT_USER;
alter table t1 add column    a24   varchar(43) default CURRENT_USER;
alter table t1 add column    a25   varchar(44) default CURRENT_USER;
alter table t1 add column    a26   varchar(45) default CURRENT_USER;
alter table t1 add column    a27   varchar(46) default CURRENT_USER;
alter table t1 add column    a28   varchar(47) default CURRENT_USER;
alter table t1 add column    a29   varchar(48) default CURRENT_USER;
alter table t1 add column    a30   varchar(49) default CURRENT_USER;
alter table t1 add column    a31   varchar(50) default CURRENT_USER;
alter table t1 add column    a32   varchar(51) default CURRENT_USER;
alter table t1 add column    a33   varchar(52) default CURRENT_USER;
alter table t1 add column    a34   varchar(53) default CURRENT_USER;
alter table t1 add column    a35   varchar(54) default CURRENT_USER;
alter table t1 add column    a36   varchar(55) default CURRENT_USER;
alter table t1 add column    a37   varchar(56) default CURRENT_USER;
alter table t1 add column    a38   varchar(57) default CURRENT_USER;
alter table t1 add column    a39   varchar(58) default CURRENT_USER;
alter table t1 add column    a40   varchar(59) default CURRENT_USER;
alter table t1 add column    a41   varchar(60) default CURRENT_USER;
alter table t1 add column    a42   varchar(61) default CURRENT_USER;
alter table t1 add column    a43   varchar(62) default CURRENT_USER;
alter table t1 add column    a44   varchar(63) default CURRENT_USER;
alter table t1 add column    a45   varchar(64) default CURRENT_USER;
alter table t1 add column    a46   varchar(65) default CURRENT_USER;
alter table t1 add column    a47   varchar(66) default CURRENT_USER;
alter table t1 add column    a48   varchar(67) default CURRENT_USER;
alter table t1 add column    a49   varchar(68) default CURRENT_USER;
alter table t1 add column    a50   varchar(69) default CURRENT_USER;
alter table t1 add column    a51   varchar(70) default CURRENT_USER;
alter table t1 add column    a52   varchar(71) default CURRENT_USER;
alter table t1 add column    a53   varchar(72) default CURRENT_USER;
alter table t1 add column    a54   varchar(73) default CURRENT_USER;
alter table t1 add column    a55   varchar(74) default CURRENT_USER;
alter table t1 add column    a56   varchar(75) default CURRENT_USER;
alter table t1 add column    a57   varchar(76) default CURRENT_USER;
alter table t1 add column    a58   varchar(77) default CURRENT_USER;
alter table t1 add column    a59   varchar(78) default CURRENT_USER;
alter table t1 add column    a60   varchar(79) default CURRENT_USER;
alter table t1 add column    a61   varchar(80) default CURRENT_USER;
alter table t1 add column    a62   varchar(81) default CURRENT_USER;
alter table t1 add column    a63   varchar(82) default CURRENT_USER;
alter table t1 add column    a64   varchar(83) default CURRENT_USER;
alter table t1 add column    a65   varchar(84) default CURRENT_USER;
alter table t1 add column    a66   varchar(85) default CURRENT_USER;
alter table t1 add column    a67   varchar(86) default CURRENT_USER;
alter table t1 add column    a68   varchar(87) default CURRENT_USER;
alter table t1 add column    a69   varchar(88) default CURRENT_USER;
alter table t1 add column    a70   varchar(89) default CURRENT_USER;
alter table t1 add column    a71   varchar(90) default CURRENT_USER;
alter table t1 add column    a72   varchar(91) default CURRENT_USER;
alter table t1 add column    a73   varchar(92) default CURRENT_USER;
alter table t1 add column    a74   varchar(93) default CURRENT_USER;
alter table t1 add column    a75   varchar(94) default CURRENT_USER;
alter table t1 add column    a76   varchar(95) default CURRENT_USER;
alter table t1 add column    a77   varchar(96) default CURRENT_USER;
alter table t1 add column    a78   varchar(97) default CURRENT_USER;
alter table t1 add column    a79   varchar(98) default CURRENT_USER;
alter table t1 add column    a80   varchar(99) default CURRENT_USER;
alter table t1 add column    a81   varchar(100) default CURRENT_USER;
alter table t1 add column    a82   varchar(101) default CURRENT_USER;
alter table t1 add column    a83   varchar(102) default CURRENT_USER;
alter table t1 add column    a84   varchar(103) default CURRENT_USER;
alter table t1 add column    a85   varchar(104) default CURRENT_USER;
alter table t1 add column    a86   varchar(105) default CURRENT_USER;
alter table t1 add column    a87   varchar(106) default CURRENT_USER;
alter table t1 add column    a88   varchar(107) default CURRENT_USER;
alter table t1 add column    a89   varchar(108) default CURRENT_USER;
alter table t1 add column    a90   varchar(109) default CURRENT_USER;
alter table t1 add column    a91   varchar(110) default CURRENT_USER;
alter table t1 add column    a92   varchar(111) default CURRENT_USER;
alter table t1 add column    a93   varchar(112) default CURRENT_USER;
alter table t1 add column    a94   varchar(113) default CURRENT_USER;
alter table t1 add column    a95   varchar(114) default CURRENT_USER;
alter table t1 add column    a96   varchar(115) default CURRENT_USER;
alter table t1 add column    a97   varchar(116) default CURRENT_USER;
alter table t1 add column    a98   varchar(117) default CURRENT_USER;
alter table t1 add column    a99   varchar(118) default CURRENT_USER;
alter table t1 add column    a100   varchar(119) default CURRENT_USER;
alter table t1 add column    a101   varchar(120) default CURRENT_USER;
alter table t1 add column    a102   varchar(121) default CURRENT_USER;
alter table t1 add column    a103   varchar(122) default CURRENT_USER;
alter table t1 add column    a104   varchar(123) default CURRENT_USER;
alter table t1 add column    a105   varchar(124) default CURRENT_USER;
alter table t1 add column    a106   varchar(125) default CURRENT_USER;
alter table t1 add column    a107   varchar(126) default CURRENT_USER;
alter table t1 add column    a108   varchar(127) default CURRENT_USER;
alter table t1 add column    a109   varchar(128) default CURRENT_USER;
alter table t1 add column    a110   varchar(129) default CURRENT_USER;
alter table t1 add column    a111   varchar(130) default CURRENT_USER;
alter table t1 add column    a112   varchar(131) default CURRENT_USER;
alter table t1 add column    a113   varchar(132) default CURRENT_USER;
alter table t1 add column    a114   varchar(133) default CURRENT_USER;
alter table t1 add column    a115   varchar(134) default CURRENT_USER;
alter table t1 add column    a116   varchar(135) default CURRENT_USER;
alter table t1 add column    a117   varchar(136) default CURRENT_USER;
alter table t1 add column    a118   varchar(137) default CURRENT_USER;
alter table t1 add column    a119   varchar(138) default CURRENT_USER;
alter table t1 add column    a120   varchar(139) default CURRENT_USER;
alter table t1 add column    a121   varchar(140) default CURRENT_USER;
alter table t1 add column    a122   varchar(141) default CURRENT_USER;
alter table t1 add column    a123   varchar(142) default CURRENT_USER;
alter table t1 add column    a124   varchar(143) default CURRENT_USER;
alter table t1 add column    a125   varchar(144) default CURRENT_USER;
alter table t1 add column    a126   varchar(145) default CURRENT_USER;
alter table t1 add column    a127   varchar(146) default CURRENT_USER;
alter table t1 add column    a128   varchar(147) default CURRENT_USER;
alter table t1 add column    a129   varchar(148) default CURRENT_USER;
alter table t1 add column    a130   varchar(149) default CURRENT_USER;
alter table t1 add column    a131   varchar(150) default CURRENT_USER;
alter table t1 add column    a132   varchar(151) default CURRENT_USER;
alter table t1 add column    a133   varchar(152) default CURRENT_USER;
alter table t1 add column    a134   varchar(153) default CURRENT_USER;
alter table t1 add column    a135   varchar(154) default CURRENT_USER;
alter table t1 add column    a136   varchar(155) default CURRENT_USER;
alter table t1 add column    a137   varchar(156) default CURRENT_USER;
alter table t1 add column    a138   varchar(157) default CURRENT_USER;
alter table t1 add column    a139   varchar(158) default CURRENT_USER;
alter table t1 add column    a140   varchar(159) default CURRENT_USER;
alter table t1 add column    a141   varchar(160) default CURRENT_USER;
alter table t1 add column    a142   varchar(161) default CURRENT_USER;
alter table t1 add column    a143   varchar(162) default CURRENT_USER;
alter table t1 add column    a144   varchar(163) default CURRENT_USER;
alter table t1 add column    a145   varchar(164) default CURRENT_USER;
alter table t1 add column    a146   varchar(165) default CURRENT_USER;
alter table t1 add column    a147   varchar(166) default CURRENT_USER;
alter table t1 add column    a148   varchar(167) default CURRENT_USER;
alter table t1 add column    a149   varchar(168) default CURRENT_USER;
alter table t1 add column    a150   varchar(169) default CURRENT_USER;
alter table t1 add column    a151   varchar(170) default CURRENT_USER;
alter table t1 add column    a152   varchar(171) default CURRENT_USER;
alter table t1 add column    a153   varchar(172) default CURRENT_USER;
alter table t1 add column    a154   varchar(173) default CURRENT_USER;
alter table t1 add column    a155   varchar(174) default CURRENT_USER;
alter table t1 add column    a156   varchar(175) default CURRENT_USER;
alter table t1 add column    a157   varchar(176) default CURRENT_USER;
alter table t1 add column    a158   varchar(177) default CURRENT_USER;
alter table t1 add column    a159   varchar(178) default CURRENT_USER;
alter table t1 add column    a160   varchar(179) default CURRENT_USER;
alter table t1 add column    a161   varchar(180) default CURRENT_USER;
alter table t1 add column    a162   varchar(181) default CURRENT_USER;
alter table t1 add column    a163   varchar(182) default CURRENT_USER;
alter table t1 add column    a164   varchar(183) default CURRENT_USER;
alter table t1 add column    a165   varchar(184) default CURRENT_USER;
alter table t1 add column    a166   varchar(185) default CURRENT_USER;
alter table t1 add column    a167   varchar(186) default CURRENT_USER;
alter table t1 add column    a168   varchar(187) default CURRENT_USER;
alter table t1 add column    a169   varchar(188) default CURRENT_USER;
alter table t1 add column    a170   varchar(189) default CURRENT_USER;
alter table t1 add column    a171   varchar(190) default CURRENT_USER;
alter table t1 add column    a172   varchar(191) default CURRENT_USER;
alter table t1 add column    a173   varchar(192) default CURRENT_USER;
alter table t1 add column    a174   varchar(193) default CURRENT_USER;
alter table t1 add column    a175   varchar(194) default CURRENT_USER;
alter table t1 add column    a176   varchar(195) default CURRENT_USER;
alter table t1 add column    a177   varchar(196) default CURRENT_USER;
alter table t1 add column    a178   varchar(197) default CURRENT_USER;
alter table t1 add column    a179   varchar(198) default CURRENT_USER;
alter table t1 add column    a180   varchar(199) default CURRENT_USER;
alter table t1 add column    a181   varchar(200) default CURRENT_USER;
insert into t1(a1) values (null);
create table t2 like t1;
insert into t2 select * from t1;
drop table t1;
drop table t2;


create table t1;
ALTER t1 ALTER column a1 SET DEFAULT USER;
drop table t1;

create table t1(a1 varchar(3));
ALTER t1 ALTER column a1 SET DEFAULT USER;
drop table t1;

create table t1(a1 varchar(10));
ALTER t1 ALTER column a1 SET DEFAULT USER;
drop table t1;

create table t1(a1 varchar(10) DEFAULT USER);
ALTER t1 ALTER column a1 SET DEFAULT USER;
drop table t1;

create table t1(a1 varchar(100));
ALTER t1 ALTER column a1 SET DEFAULT USER;
ALTER t1 change column a1 a1 date;
ALTER t1 ALTER column a1 SET DEFAULT SYSDATE;
drop table t1;

create table t1(a1 varchar(100));
ALTER t1 ALTER column a1 SET DEFAULT USER;
ALTER t1 change column a1 a1 date;
ALTER t1 ALTER column a1 SET DEFAULT SYSDATE;
drop table t1;

create table t1(a1 int auto_increment);
ALTER t1 ALTER column a1 SET DEFAULT USER;
drop table t1;


create table t1(a1 int auto_increment);
ALTER t1 add column a2 varchar(6) DEFAULT USER;
drop table t1;

create table t1(a1 varchar not null, b int);
--CUBRIDSUS-8035
ALTER t1 ALTER column a1 SET DEFAULT null;
drop table t1;

create table t1(a1 varchar not null default null, b int);
drop table t1;

create table t1(a1 varchar not null default USER, b int);
insert into t1(b) values (1);
select * from t1 order by 1,2;
drop table t1;

create table t1(a1 timestamp not null default CURRENT_TIMESTAMP, b int);
insert into t1(b) values (1);
drop table t1;



create table t1(a1 varchar default USER, b int);
insert into t1(b) values (1);
create view v1 as select * from t1;
insert into v1(b) values (2);
insert into t1(b) values (3);
select * from t1 order by b;
drop table t1;
drop view v1;


create table t1(a1 varchar(3) default USER, b int);
insert into t1(b) values (1);
--TODO: must return one record.
select * from t1;
drop table t1;


create table t1(a1 varchar(20) default USER, b int);
create view v1 as select * from t1;
--CUBRIDSUS-8038
insert into v1(a1, b) values (default, 4);
select * from t1 order by 1,2;
drop table t1;
drop view v1;


create table t1(a1 varchar(20) default USER, b int);
create view v1 as select * from t1;
insert into v1(a1, b) values (default(a1), 4);
select * from t1 order by 1,2;
drop table t1;
drop view v1;


create table t1(a1 varchar(20) unique default USER, b int);
insert into t1(a1, b) values (default, 1);
insert into t1(a1, b) values (default(a1), 1);
drop table t1;


create table t1(a1 varchar(20) PRIMARY KEY default USER, b int);
insert into t1(a1, b) values (default, 1);
insert into t1(a1, b) values (default(a1), 1);
drop table t1;

create table t1(a1 varchar(20) default USER, b int);
create view v1 as select * from t1;
insert into v1(b) values (4);
insert into t1 select default(a1), b from t1 ;
drop table t1;
drop view v1;

create table t1(a1 varchar(100) default USER, b int);
insert into t1(b) values (1);
select * from t1 order by 1,2;
drop table t1;



set @a=USER;
create table t1(a varchar(100) default @a, b int);
insert into t1(b) values (1);
select * from t1 order by 1,2;
drop table t1;


drop table t1;
create table t1(a varchar(100) default 'USER', b int);
insert into t1(b) values (1);
alter table t1 alter a set default USER;
insert into t1(b) values (2);
select * from t1 order by 1;
drop table t1;

set @a=USER;
create table t1(a varchar(100) default 'USER', b int);
insert into t1(b) values (1);
alter table t1 alter a set default @a;
insert into t1(b) values (2);
select * from t1 order by 1;
drop table t1;


create table t1(a varchar(100) default USER, b int);
create view v1 as select * from t1 order by 1,2;
alter table v1 alter a set default @a;
drop table t1;
drop view v1;


create table t1(a varchar(100) default USER null, b int);
insert into t1(b) values (1);
select * from t1 order by 1 desc, 2 desc;
drop table t1;


create table t1(a varchar(100) default USER not null, b int);
insert into t1(b) values (1);
select * from t1 order by 1 desc, 2 desc;
drop table t1;


create table t1(a varchar(100) default USER, b int);
create index i_t1_b_a on t1 (abs(b), a);
insert into t1(b) values (1);
select * from t1 order by 1 desc, 2 desc;
drop table t1;


create table t1(a varchar(100) default USER primary key, b int);
create index i_t1_b_a on t1 (abs(b), a);
insert into t1(b) values (1);
insert into t1(b) values (1);
select * from t1 order by 1 desc, 2 desc;
drop table t1;



create table t1(a varchar(100) default USER unique, b int);
create index i_t1_b_a on t1 (abs(b), a);
insert into t1(b) values (1);
insert into t1(b) values (1);
select * from t1 order by 1 desc, 2 desc;
drop table t1;

create table t1(a varchar(100) default USER, b int);
create index i_t1_a on t1 (length(a));
insert into t1(b) values (1);
insert into t1(b) values (1);
select * from t1 order by 1 desc, 2 desc;
select /*+ recompile */ * from t1 where length(a) >=1;
drop table t1;


create table t1(a varchar(100) default USER, b int);
insert into t1 value (null, null);
select default(a.a), default(a.b), default(b.a), default(b.b) from t1 a, t1 b;
drop table t1;


create table t1(a varchar(100) default USER, b int);
insert into t1 value (null, null);
create table t2(a varchar default USER, b varchar default USER, c varchar default USER, d varchar default USER) as select default(a.a) a, default(a.b) b, default(b.a) c, default(b.b) d from t1 a, t1 b;
insert into t2(a) values (null);
select * from t2 order by 1 desc, 2 desc, 3 asc, 4 asc;
desc t2;
drop table t1;
drop table t2;

create table t1(a varchar(100) default 'AAA', b int);
create view v1 as select * from t1 order by 1,2;
alter view v1 alter a set default USER;
insert into v1(b) values (1);
insert into t1(b) values (2);
select * from v1 order by 1 desc;
drop table t1;
drop view v1;


create table t1(a varchar(100) default 'AAA', b int);
create view v1 as select * from t1 order by 1,2;
alter view v1 alter a set default USER;
insert into v1(b) values (1);
insert into t1(b) values (2);
insert into v1(a,b) values (default, 3);
insert into t1(a,b) values (default, 4);
select * from v1 order by 1 desc, 2 desc;
drop table t1;
drop view v1;

create table t1(a varchar(100) default 'AAA', b int);
create view v1 as select * from t1 order by 1,2;
alter view v1 alter a set default USER;
insert into v1(b) values (1);
insert into t1(b) values (2);
insert into v1(a,b) values (default, 3);
insert into t1(a,b) values (default, 4);
update v1 set a=default, b=5 where b=2;
update v1 set a=default, b=6 where b=4;
select * from v1 order by 2 desc, 1 desc;
update v1 set a=default, b=7 where b=1;
update t1 set a=default, b=8 where b=3;
select * from v1 order by 2 desc, 1 desc;
drop table t1;
drop view v1;


create table t1(a varchar(100) default 'AAA', b int);
create view v1 as select * from t1 order by 1,2;
alter view v1 alter a set default USER;
insert into v1(b) values (1);
insert into t1(b) values (2);
insert into v1(a,b) values (default, 3);
insert into t1(a,b) values (default, 4);
update v1 set a=default, b=5 where b=2;
update v1 set a=default, b=6 where b=4;
select * from v1 order by 2 desc, 1 desc;
update v1 set a=default, b=7 where b=1;
update t1 set a=default, b=8 where b=3;
select * from v1 order by 2 desc, 1 desc;
select default(t1.a), default(v1.a) from t1, v1 limit 1;
ALTER TABLE t1 ADD COLUMN (c char(1024) default USER, d varchar(20) default USER, e date default sysdate);
drop table t1;
drop view v1;


create table t1 (a varchar(100) default USER, b int)
PARTITION BY HASH (a) PARTITIONS 4;
alter table t1 alter a set default 'AAA';
alter table t1 alter a set default USER;
desc t1;
drop table t1;


create table t1 (a varchar(100) default USER unique, b int unique);
insert into t1 (b) values (1);
insert into t1 (a,b) values ('AAA',3);
insert into t1 (b) values (1) ON DUPLICATE KEY UPDATE a=default;
select * from t1 order by 2;
drop table t1;

create table t1 (a varchar(100) default USER unique, b int);
insert into t1 (b) values (1);
insert into t1 (a,b) values ('AAA',3);
insert into t1 (b) values (1) ON DUPLICATE KEY UPDATE a='AAA';
select * from t1 order by 2;
drop table t1;

create table t1 (a varchar(100) default USER, b int)
PARTITION BY HASH (a) PARTITIONS 4;
set @a=USER;
alter table t1 alter a set default USER;
show t1;
drop table t1;


create table t1 (a varchar(100) default USER, b int)
PARTITION BY HASH (a) PARTITIONS 4;
CALL add_user('test1','test1') ON CLASS db_user;
CALL add_user('test2','test2') ON CLASS db_user;
GRANT INSERT ON ALL t1 TO test1, test2;
GRANT SELECT ON ALL t1 TO test1, test2;
CALL login('test1','test1') ON CLASS db_user;
insert into dba.t1(b) values (1);
CALL login('test2','test2') ON CLASS db_user;
insert into dba.t1(b) values (2);
CALL login('dba','') ON CLASS db_user;
select * from t1 order by 1,2;
drop table t1;
CALL drop_user('test1') ON CLASS db_user;
CALL drop_user('test2') ON CLASS db_user;


create table t1 (a varchar(100) default USER unique, b int)
PARTITION BY HASH (a) PARTITIONS 4;
CALL add_user('test1','test1') ON CLASS db_user;
CALL add_user('test2','test2') ON CLASS db_user;
GRANT INSERT ON ALL t1 TO test1, test2;
GRANT SELECT ON ALL t1 TO test1, test2;
CALL login('test1','test1') ON CLASS db_user;
insert into dba.t1(b) values (1);
CALL login('test2','test2') ON CLASS db_user;
insert into dba.t1(b) values (2);
CALL login('dba','') ON CLASS db_user;
select * from t1 order by 1,2;
drop table t1;
CALL drop_user('test1') ON CLASS db_user;
CALL drop_user('test2') ON CLASS db_user;

show tables;
drop variable @a;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
