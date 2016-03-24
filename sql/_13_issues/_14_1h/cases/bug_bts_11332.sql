create table t1 (a int, b int);
insert into t1 values(1,2),(3,4);
select count(distinct b) from t1 group by a with rollup;
drop table t1;


create table c(
       col_varchar_10_key character varying(10),
       col_int integer,
       col_int_key integer,
       col_varchar_10 character varying(10),
       col_varchar_1024_key character varying(1024),
       pk integer primary key,
       col_varchar_1024 character varying(1024));

create table bb(
       col_int_key integer,
       col_varchar_1024 character varying(1024),
       col_varchar_10_key character varying(10),
       col_varchar_1024_key character varying(1024),
       pk integer primary key,
       col_int integer,
       col_varchar_10 character varying(10));
CREATE INDEX col_varchar_10_key_idx ON c (col_varchar_10_key);
CREATE INDEX col_int_key_idx ON c (col_int_key);
CREATE INDEX col_varchar_1024_key_idx ON c (col_varchar_1024_key);
CREATE INDEX col_int_key_idx ON bb (col_int_key);
CREATE INDEX col_varchar_10_key_idx ON bb (col_varchar_10_key);
CREATE INDEX col_varchar_1024_key_idx ON bb (col_varchar_1024_key);
insert into c values('w',1494482944,89653248,NULL,'t',1,'l');
insert into c values('h',-2015756288,1371078656,'v',NULL,2,'m');
insert into c values('n',49741824,-515833856,'k','d',3,'a');
insert into c values(NULL,-818413568,19645,'e',NULL,4,'p');
insert into c values('t',NULL,11013,'z','w',5,'h');
insert into c values('e',-1151074304,13683,'t','r',6,'p');
insert into c values(NULL,-261226496,-2848,'e','j',7,NULL);
insert into c values(NULL,-17879,759627776,'r',NULL,8,NULL);
insert into c values('i',1485307904,-1554972672,NULL,'s',9,'r');
insert into c values('p',-83755008,548929536,NULL,'z',10,'w');
insert into c values('v',-134873088,1679228928,NULL,'m',11,'r');
insert into c values(NULL,993132544,1081933824,'i',NULL,12,'s');
insert into c values('v',23467,-1165033472,'w','q',13,'f');
insert into c values(NULL,-1756495872,13521,'a','v',14,'f');
insert into c values('m',-883556352,21757,'o','h',15,'o');
insert into c values('d',-2094268416,187236352,'z','o',16,'q');
insert into c values('g',11845,-1856569344,NULL,'i',17,'f');
insert into c values('c',-641400832,13135,'r',NULL,18,'r');
insert into c values('i',NULL,962265088,'s','l',19,'b');
insert into c values(NULL,17857,-1562574848,'r','d',20,'v');
insert into c values(NULL,800325632,1238958080,'x','x',21,'f');
insert into c values('s',15615,1687289856,'u','q',22,NULL);
insert into c values('o',-1717305344,-1962672128,'t','k',23,'w');
insert into c values('v',464453632,-15793,NULL,'p',24,NULL);
insert into c values(NULL,-814612480,-1232863232,NULL,'t',25,'r');
insert into c values(NULL,15126,-581435392,'o',NULL,26,'p');
insert into c values('z',-1537146880,28042,'c','c',27,'k');
insert into c values('h',NULL,-528547840,NULL,'y',28,'r');
insert into c values('u',1840447488,159121408,'h','x',29,'e');
insert into c values('k',-1676214272,-1877278720,'g','y',30,'k');
insert into c values(NULL,NULL,-662241280,'t','c',31,'p');
insert into c values('l',1530068992,NULL,'x','l',32,'z');
insert into c values(NULL,805765120,17296,'l','d',33,'m');
insert into c values('v',NULL,-2130771968,'k','b',34,'h');
insert into c values(NULL,-623771648,-1067057152,'p',NULL,35,'a');
insert into c values('z',1213923328,-1121320960,'d','m',36,'a');
insert into c values('i',-1668087808,-17168,'j','l',37,'h');
insert into c values('p',NULL,-989724672,'m','k',38,'z');
insert into c values('q',19938,-15845,'w','o',39,NULL);
insert into c values('b',-38141952,-10974,NULL,'c',40,'p');
insert into c values('z',NULL,319946752,'d','g',41,'v');
insert into c values('h',27267,NULL,'f',NULL,42,'r');
insert into c values(NULL,1391853568,-9039,'g','x',43,'a');
insert into c values('j',1364328448,NULL,'n','o',44,'q');
insert into c values('z',-52166656,NULL,NULL,'q',45,'c');
insert into c values('d',NULL,8157,'k','r',46,'a');
insert into c values(NULL,-1564082176,21628,'i','u',47,'m');
insert into c values('p',-463142912,-7011,NULL,'f',48,NULL);
insert into c values('q',1638465536,197918720,NULL,'m',49,'n');
insert into c values(NULL,1399980032,-554434560,NULL,'l',50,'w');
insert into bb values(-1943207936,'d','m','c',1,9851,'x');
insert into bb values(NULL,'w','y','j',2,-27801,'g');
insert into bb values(163250176,'i','m','k',3,-144769024,'z');
insert into bb values(1821376512,NULL,'x','e',4,-1898315776,'x');
insert into bb values(-26017,'s',NULL,'x',5,-946864128,'k');
insert into bb values(-1476,'l',NULL,'z',6,142606336,'k');
insert into bb values(-163708928,'e',NULL,'y',7,NULL,'q');
insert into bb values(468647936,'x','i','g',8,7342,'n');
insert into bb values(-6081,'i','s',NULL,9,NULL,'f');
insert into bb values(311820288,'b','w','p',10,764477440,'t');
insert into bb values(NULL,NULL,NULL,NULL,11,NULL,NULL);
insert into bb values(2660,'t','v','a',12,NULL,'j');
insert into bb values(NULL,'u','x','a',13,NULL,'y');
insert into bb values(6679,'m','d','j',14,647954432,'x');
insert into bb values(-409075712,NULL,NULL,NULL,15,13537,'h');
insert into bb values(1694564352,'b','v','r',16,2019819520,'a');
insert into bb values(1633288192,'r','r','r',17,NULL,'z');
insert into bb values(1777336320,'l','n','d',18,24117,'r');
insert into bb values(-2021916672,'o','k','k',19,1106706432,'o');
insert into bb values(16008,'h','t',NULL,20,-19191,'o');
insert into bb values(1618477056,'n','l',NULL,21,1341521920,'z');
insert into bb values(-1555955712,'q','v',NULL,22,NULL,'q');
insert into bb values(-1566507008,'c',NULL,'v',23,-1791557632,'h');
insert into bb values(2069364736,'g','f','n',24,-181207040,'w');
insert into bb values(NULL,'l','d','t',25,NULL,'p');
insert into bb values(531824640,'l','l','c',26,NULL,NULL);
insert into bb values(-647233536,'v','m','t',27,NULL,'y');
insert into bb values(-670367744,'k','f','x',28,765263872,'e');
insert into bb values(NULL,'s','a','q',29,-1455751168,'q');
insert into bb values(708444160,'w','y','o',30,-963641344,'b');
insert into bb values(2028142592,'l',NULL,'b',31,-1865875456,NULL);
insert into bb values(-797966336,'c',NULL,NULL,32,-323551232,NULL);
insert into bb values(NULL,'k','s','o',33,-23822,'d');
insert into bb values(23550,'r','u','h',34,NULL,'l');
insert into bb values(-876085248,'n','u','a',35,1993146368,NULL);
insert into bb values(89194496,'y',NULL,'v',36,28169,'z');
insert into bb values(-29021,'u',NULL,'s',37,-13632,'z');
insert into bb values(1369440256,NULL,'a','r',38,1716125696,'i');
insert into bb values(2804,'t',NULL,NULL,39,1016135680,'z');
insert into bb values(833748992,'v','h','y',40,-1322778624,'a');
insert into bb values(1150091264,NULL,'z',NULL,41,1674510336,'z');
insert into bb values(685113344,NULL,'u','o',42,1979580416,'x');
insert into bb values(-1431175168,NULL,'f','m',43,475070464,'o');
insert into bb values(-677249024,'c','u',NULL,44,422,'i');
insert into bb values(1165426688,'d','a','y',45,85524480,'v');
insert into bb values(-17930,'c','c','y',46,-1818492928,'m');
insert into bb values(2029453312,NULL,'r','l',47,NULL,'t');
insert into bb values(NULL,NULL,'j','m',48,1027735552,'q');
insert into bb values(1218510848,NULL,'u','n',49,1349582848,'i');
insert into bb values(240975872,'m','u','p',50,-888602624,'u');
SELECT  COUNT(DISTINCT OUTR . col_int ) AS X FROM C AS OUTR WHERE OUTR . col_varchar_1024_key IN ( SELECT  INNR . col_varchar_10 AS Y FROM BB AS INNR WHERE INNR . col_int IS NULL  ) AND OUTR . col_int_key > 5 AND OUTR . col_varchar_10_key <> 'l' GROUP BY OUTR . col_int WITH ROLLUP HAVING X <= 8 ORDER BY OUTR . col_int , OUTR . pk;
drop table c;
drop table bb;
