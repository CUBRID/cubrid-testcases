--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists fjj;
drop table if exists lwe;

CREATE class fjj(
"mid" character varying(20) NOT NULL,
"fvid" character varying(20) NOT NULL,
"fatid" character varying(10) NOT NULL,
"edt" timestamp NOT NULL,
"wfnmt" integer DEFAULT 1 NOT NULL,
CONSTRAINT pk_fjj_mid_fvid_fatid PRIMARY KEY("mid","fvid","fatid")
);

CREATE class lwe(
"aiid" character varying(20) NOT NULL,
"atid" character varying(10) NOT NULL,
"wmj" integer NOT NULL,
"shdt" timestamp,
"swdt" timestamp,
"hnmt" integer DEFAULT 0 NOT NULL,
CONSTRAINT pk_lwe_aiid_wmj_atid PRIMARY KEY("aiid","atid","wmj")
);

insert into fjj values('TEST1000001','DEV200000','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200001','NO123','2014-05-11',1);
insert into fjj values('TEST1000001','DEV200002','NO123','2014-06-11',1);
insert into fjj values('TEST1000001','DEV200003','NO123','2014-08-11',1);
insert into fjj values('TEST1000001','DEV200004','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200005','NO123','2014-09-12',1);
insert into fjj values('TEST1000001','DEV200006','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200007','NO123','2014-04-12',1);
insert into fjj values('TEST1000001','DEV200008','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200009','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200000','NO129','2014-04-15',1);
insert into fjj values('TEST1000001','DEV200001','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200002','NO129','2014-04-16',1);
insert into fjj values('TEST1000001','DEV200003','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200004','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200005','NO129','2014-04-13',1);
insert into fjj values('TEST1000001','DEV200006','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200007','NO129','2014-04-12',1);
insert into fjj values('TEST1000001','DEV200008','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200009','NO129','2014-04-11',1);

insert into fjj values('TEST1000001','DEV200010','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200011','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200012','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200013','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200014','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200015','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200016','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200017','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200018','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200019','NO123','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200010','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200011','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200012','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200013','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200014','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200015','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200016','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200017','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200018','NO129','2014-04-11',1);
insert into fjj values('TEST1000001','DEV200019','NO129','2014-04-11',1);

insert into fjj values('TEST1000011','DEV200000','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200001','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200002','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200003','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200004','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200005','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200006','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200007','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200008','NO129','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200009','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200000','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200001','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200002','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200003','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200004','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200005','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200006','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200007','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200008','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200009','NO129','2014-04-11',1);

insert into fjj values('TEST1000011','DEV200110','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200111','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200112','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200113','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200114','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200115','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200116','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200117','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200118','NO123','2014-04-11',1);
insert into fjj values('TEST1000011','DEV200119','NO123','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200120','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200121','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200122','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200123','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200124','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200125','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200126','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200127','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200128','NO129','2014-04-11',1);
insert into fjj values('TEST1000021','DEV200129','NO129','2014-04-11',1);

insert into fjj values('TEST1000111','DEV200210','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200211','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200212','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200213','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200214','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200215','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200216','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200217','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200218','NO123','2014-04-11',1);
insert into fjj values('TEST1000111','DEV200219','NO123','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200220','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200221','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200222','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200223','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200224','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200225','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200226','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200227','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200228','NO129','2014-04-11',1);
insert into fjj values('TEST1000121','DEV200229','NO129','2014-04-11',1);

insert into lwe values('DEV200000','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200001','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200002','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200003','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200004','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200005','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200006','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200007','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200008','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200009','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200000','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200001','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200002','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200003','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200004','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200005','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200006','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200007','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200008','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200009','NO129',40145,'2014-04-11','2014-02-11',0);

insert into lwe values('DEV200010','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200011','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200012','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200013','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200014','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200015','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200016','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200017','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200018','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200019','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200020','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200021','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200022','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200023','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200024','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200025','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200026','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200027','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200028','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200029','NO123',40145,'2014-04-11','2014-02-11',0);

insert into lwe values('DEV200210','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200211','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200212','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200213','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200214','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200215','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200216','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200217','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200218','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200219','NO123',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200220','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200221','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200222','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200223','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200224','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200225','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200226','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200227','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200228','NO123',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200229','NO123',40145,'2014-04-11','2014-02-11',0);

insert into lwe values('DEV200210','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200211','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200212','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200213','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200214','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200215','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200216','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200217','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200218','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200219','NO129',40045,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200220','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200221','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200222','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200223','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200224','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200225','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200226','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200227','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200228','NO129',40145,'2014-04-11','2014-02-11',0);
insert into lwe values('DEV200229','NO129',40145,'2014-04-11','2014-02-11',0);
update statistics on fjj with fullscan;
update statistics on lwe with fullscan;

set optimization level 513;

--@queryplan
SELECT /*+ recompile */ count (b.aiid) FROM fjj a LEFT JOIN lwe b ON b.aiid = a.fvid AND b.wmj = 40045 AND b.atid = a.fatid WHERE a.mid = 'TEST1000001' AND b.aiid is null;

--@queryplan
SELECT /*+ recompile */ count (b.aiid) FROM fjj a LEFT JOIN lwe b ON b.aiid = a.fvid   AND b.wmj = 40045 AND b.atid = a.fatid WHERE  a.mid = 'TEST1000001';

--@queryplan
SELECT /*+ recompile */ count (b.aiid) FROM fjj a LEFT JOIN lwe b ON b.aiid = a.fvid   AND b.wmj = 40045 AND b.atid = a.fatid;

set system parameters 'optimizer_enable_merge_join=yes';

--@queryplan
SELECT /*+ recompile */count (b.aiid) FROM fjj a LEFT JOIN lwe b ON b.aiid = a.fvid AND b.wmj = 40045 AND b.atid = a.fatid WHERE a.mid = 'TEST1000001' AND b.aiid is null;

--@queryplan
SELECT /*+ recompile */ count (b.aiid) FROM fjj a LEFT JOIN lwe b ON b.aiid = a.fvid   AND b.wmj = 40045 AND b.atid = a.fatid WHERE a.mid='TEST1000001';

--@queryplan
SELECT /*+ recompile */ count (b.aiid) FROM fjj a LEFT JOIN lwe b ON b.aiid = a.fvid   AND b.wmj = 40045 AND b.atid = a.fatid;


drop table fjj;
drop table lwe;
set system parameters 'optimizer_enable_merge_join=no';
set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
