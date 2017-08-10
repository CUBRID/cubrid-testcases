create table t1 reuse_oid;
ALTER CLASS [t1] ADD ATTRIBUTE
       [eid] integer AUTO_INCREMENT(1, 1) NOT NULL,
       [aid] integer,
       [rid] integer,
       [cno] character varying(10),
       [cnm] character varying(30),
       [shape] character varying(5),
       [hn] character varying(100),
       [ia] character varying(30),
       [trst] character varying(10),
       [oy] character varying(14),
       [ry] character varying(14),
       [mc] character varying(1073741823),
       [zvd] character varying unique,
       [pr] character varying(32),
       [fa] character varying(32),
       [pro] character varying(32),
	   [ru] character varying(32); 


ALTER CLASS [t1] ADD ATTRIBUTE
       CONSTRAINT [pk_t1_eid_zvd] PRIMARY KEY([eid],[zvd]);

alter table t1 partition by list (zvd) ( 
 partition "p_20110701" values in ('20110701' ) ,
 partition "p_20110702" values in ('20110702' ) ,
 partition "p_20110703" values in ('20110703' ) ,
 partition "p_20110704" values in ('20110704' ) ,
 partition "p_20110705" values in ('20110705' ) ,
 partition "p_20110706" values in ('20110706' ) ,
 partition "p_20110707" values in ('20110707' ) ,
 partition "p_20110708" values in ('20110708' ) ,
 partition "p_20110709" values in ('20110709' ) ,
 partition "p_20110710" values in ('20110710' ) ,
 partition "p_20110711" values in ('20110711' ) ,
 partition "p_20110712" values in ('20110712' ) ,
 partition "p_20110713" values in ('20110713' ) ,
 partition "p_20110714" values in ('20110714' ) ,
 partition "p_20110715" values in ('20110715' ) ,
 partition "p_20110716" values in ('20110716' ) ,
 partition "p_20110717" values in ('20110717' ) ,
 partition "p_20110718" values in ('20110718' ) ,
 partition "p_20110719" values in ('20110719' ) 
 );

create INDEX idx1_t1 ON t1 (oy);
create INDEX idx3_t1 ON t1 (pr);
create INDEX idx2_t1 ON t1 (zvd, trst, oy DESC);

SELECT  /*+ RECOMPILE */          W. eid,            W.aid,
        W.rid,            W.oy,            W.cno,            W.cnm,
        W.shape,            W.mc,            W.hn,            W.ia,
        DECODE(NVL(W.trst,'00'),'00', '쨔횑쨀쨍짰','99','처쨍짰','') trst,
        W.pr,           W.fa,           W.ru
FROM   t1 W
WHERE  zvd = '20110729'
AND    W.trst = '00'
using index idx2_t1(+)
ORDER BY oy desc
for orderby_num() BETWEEN (1*50-50+1) AND (1*50);

SELECT  /*+ RECOMPILE */          W. eid,            W.aid,
        W.rid,            W.oy,            W.cno,            W.cnm,
        W.shape,            W.mc,            W.hn,            W.ia,
        DECODE(NVL(W.trst,'00'),'00', '쨔횑쨀쨍짰','99','처쨍짰','') trst,
        W.pr,           W.fa,           W.ru
FROM   t1__p__p_20110719 W
WHERE  zvd = '20110729'
AND    W.trst = '00'
using index idx2_t1(+)
ORDER BY oy desc
for orderby_num() BETWEEN (1*50-50+1) AND (1*50);

drop table t1;
