--+ holdcas on;
CREATE TABLE t (i int, s string);

INSERT INTO t VALUES (6727,'kx'), (9883,'cs'), (5770,'yu'), (6397,'dy'), (4818,'rn'), (4177,'hv'), (8515,'ou'), (6667,'kf'), (1350,'kt'), (6078,'eu');
INSERT INTO t VALUES (4370,'aaaaa'), (2982,'rz'), (9833,'pn'), (2666,'qh'), (7977,'zc'), (7696,'py'), (3243,'zo'), (1249,'sf'), (9637,'rv'), (1933,'rn');
INSERT INTO t VALUES (7774,'ii'), (4396,'fl'), (664,'oo'), (7107,'ib'), (2853,'sd'), (5692,'sx'), (9240,'uw'), (3273,'zr'), (7121,'de'), (4654,'qf');
INSERT INTO t VALUES (8932,'bq'), (5218,'br'), (5044,'xq'), (4242,'wt'), (7088,'uz'), (2256,'ud'), (3875,'id'), (9412,'qt'), (5267,'oo'), (2639,'ut');
INSERT INTO t VALUES (5618,'bj'), (135,'sf'), (8920,'eq'), (8546,'ps'), (3708,'pd'), (7328,'kh'), (8491,'xx'), (2571,'ul'), (9087,'ov'), (5133,'gf');
INSERT INTO t VALUES (9135,'ym'), (1648,'of'), (5357,'je'), (7982,'hk'), (1229,'ud'), (9365,'ex'), (7702,'dj'), (5883,'zj'), (8883,'uq'), (2585,'ln');
INSERT INTO t VALUES (5276,'kz'), (6369,'is'), (8616,'uq'), (3326,'zw'), (1721,'it'), (6540,'ju'), (5400,'wp'), (1830,'lh'), (3534,'te'), (3646,'yz');
INSERT INTO t VALUES (8258,'hh'), (1766,'xl'), (935,'yz'), (7633,'gv'), (2592,'ls'), (3487,'tb'), (961,'zb'), (4116,'of'), (1445,'ev'), (6310,'qq');
INSERT INTO t VALUES (7441,'qz'), (1180,'qp'), (2872,'zd'), (5717,'ou'), (7553,'op'), (8480,'sl'), (5610,'qu'), (6451,'kz'), (9664,'jk'), (2057,'sj');
INSERT INTO t VALUES (246,'pg'), (7419,'cv'), (2110,'dv'), (3319,'qc'), (8042,'gs'), (9354,'ek'), (7634,'xf'), (5615,'dr'), (4649,'yt'), (1163,'zg');
INSERT INTO t VALUES (3145,'lz'), (6846,'nm'), (845,'zf'), (5910,'ot'), (9506,'lq'), (1548,'ih'), (7533,'fk'), (2363,'qv'), (1025,'oo'), (889,'sn');
INSERT INTO t VALUES (7149,'px'), (3042,'rp'), (9336,'td'), (4007,'ux'), (8696,'eb'), (4714,'zy'), (1372,'rb'), (9140,'xi'), (8571,'bh'), (2260,'gx');
INSERT INTO t VALUES (6099,'dl'), (7971,'rz'), (4379,'en'), (1866,'he'), (9713,'qv'), (1644,'rk'), (3929,'hx'), (4463,'pg'), (3972,'gh'), (1864,'ol');
INSERT INTO t VALUES (6590,'bu'), (5358,'gp'), (7376,'ie'), (5543,'qi'), (9198,'xe'), (997,'mf'), (3849,'ou'), (6417,'ey'), (3700,'yy'), (8794,'fw');
INSERT INTO t VALUES (8641,'gf'), (2066,'oi'), (8725,'sb'), (958,'nk'), (6117,'tk'), (9792,'ec'), (2271,'sn'), (8274,'ph'), (9134,'qu'), (9773,'gz');
INSERT INTO t VALUES (7688,'pl'), (4748,'th'), (4682,'st'), (8946,'wy'), (149,'fc'), (9077,'vm'), (5482,'cv'), (4046,'hm'), (5805,'tt'), (7771,'by');

select count(*) from t;

select sum(tt.col) from (select i as col from t order by i limit 10 ) as tt;
select sum(tt.col) from (select i as col from t order by i limit 100) as tt;

select sum(tt.col) from (select i as col from t order by i desc limit 10 ) as tt;
select sum(tt.col) from (select i as col from t order by i desc limit 100) as tt;

select sum(tt.col) from (select i as col from t order by abs(i-5000),i limit 11 ) as tt;

select * from t order by s,i limit 40;
select s from t order by s desc limit 10;

-- CUBRIDSUS-4850
select * from t order by s for orderby_num() < 0;

-- timed tests
create table u as select * from t;

create table times (id int, start bigint, stop bigint);
insert into times values (1,0,0);
insert into times values (2,0,0);

update times set start = unix_timestamp() where id = 2;
select 1 from (select i as col1 from t order by i limit 1000) t join (select i as col2 from u order by i desc limit 1000) u on true order by abs((col1+col2)/2) limit 10;
update times set stop = unix_timestamp() where id = 2;

set system parameters 'use_orderby_sort_limit=no';
select 1 from (select i as col1 from t order by i limit 1000) t join (select i as col2 from u order by i desc limit 1000) u on true order by abs((col1+col2)/2) limit 10;

-- CUBRIDSUS-4850 for use_orderby_sort=no
select * from t order by s for orderby_num() < 0;


drop table times;
drop table u;
-- end timed tests

set system parameters 'use_orderby_sort_limit=yes';

select sum(tt.col) as sum_00 from (select i as col from t order by i limit   0) as tt;
select sum(tt.col) as sum_01 from (select i as col from t order by i limit   1) as tt;
select sum(tt.col) as sum_02 from (select i as col from t order by i limit   2) as tt;
select sum(tt.col) as sum_03 from (select i as col from t order by i limit   3) as tt;

select sum(tt.col) as sum_100 from (select i as col from t order by i limit  100) as tt;
select sum(tt.col) as sum_200 from (select i as col from t order by i limit  200) as tt;
select sum(tt.col) as sum_400 from (select i as col from t order by i limit  400) as tt;
select sum(tt.col) as sum_800 from (select i as col from t order by i limit  800) as tt;
select sum(tt.col) as sum_1600 from (select i as col from t order by i limit  1600) as tt;

delete from t where i > 2000;

-- 2 -> 8
update t set s = s + s + s + s;

-- 8 -> 32
update t set s = s + s + s + s;

-- 128
update t set s = s + s + s + s;

-- 512
update t set s = s + s + s + s;

-- 2048
update t set s = s + s + s + s;

-- 8192
update t set s = s + s + s + s;

-- 32768: certainly into overflow pages already
update t set s = s + s + s + s;

-- 131072 bytes each: definiteley overflow pages here
-- update t set s = s + s + s + s;

select length(s) from t limit 1;

select substr(s,1,2) from t order by s,i limit 10;

delete from t where i > 200;

select substr(s,1,2) from t order by s,i limit 201;

drop table t;
commit;
--+ holdcas off;
