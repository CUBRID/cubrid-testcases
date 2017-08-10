create table k(
       col_int_key integer,
       pk integer AUTO_INCREMENT(1, 1) NOT NULL primary key,
       col_varchar_10_key character varying(10) ,
       col_varchar_10 character varying(10) ,
       col_int integer,
       col_varchar_1024 character varying(1024) ,
       col_varchar_1024_key character varying(1024) );


create table h(
       col_int_key integer,
       col_varchar_1024 character varying(1024) ,
       col_varchar_1024_key character varying(1024) ,
       col_varchar_10_key character varying(10) ,
       col_int integer,
       col_varchar_10 character varying(10) ,
       pk integer AUTO_INCREMENT(1, 1) NOT NULL primary key);


create table i(
       col_varchar_1024_key character varying(1024) ,
       col_varchar_1024 character varying(1024) ,
       col_int integer,
       col_int_key integer,
       col_varchar_10 character varying(10) ,
       pk integer AUTO_INCREMENT(1, 1) NOT NULL primary key,
       col_varchar_10_key character varying(10)) ;

insert into k values(2066415616,1,'u','m',NULL,'r',NULL);
insert into k values(-1506934784,2,NULL,'c',1320681472,'a',NULL);
insert into k values(NULL,3,'w','a',8820,'i',NULL);
insert into k values(-672268288,4,'w','z',-30345,'b','w');
insert into k values(1148911616,5,'h',NULL,-24434,'d','j');
insert into k values(-2043740160,6,'i','t',275447808,'f','d');
insert into k values(-1908080640,7,'s','d',801636352,'o',NULL);
insert into k values(NULL,8,'c','u',13893632,'j','s');
insert into k values(-30737,9,'f','k',NULL,'a','g');
insert into k values(NULL,10,'w','w',-875102208,'l','a');
insert into k values(-1491664896,11,'a','g',1051787264,'i','x');
insert into k values(-569573376,12,'p','z',NULL,NULL,'l');
insert into k values(-30728,13,NULL,'q',1753481216,'r','s');
insert into k values(354484224,14,'j','k',NULL,'n','i');
insert into k values(NULL,15,NULL,'n',750911488,NULL,'v');
insert into k values(-325976064,16,'r','r',27068,'c','z');
insert into k values(592904192,17,'l','s',31963,'v','k');
insert into k values(-570884096,18,'t','s',NULL,NULL,'f');
insert into k values(-32463,19,'e','i',-1433600000,'f','e');
insert into k values(-1536425984,20,'m',NULL,2136866816,'v',NULL);
insert into k values(1111687168,21,'e','s',370868224,'v','j');
insert into h values(-1232863232,'k','c','v',13348,NULL,1);
insert into h values(NULL,'x',NULL,'p',-17212,'b',2);
insert into h values(-64421888,'s','i','w',-1221853184,'n',3);
insert into h values(NULL,'u','r','n',616431616,'t',4);
insert into h values(NULL,'h','f','b',-1462960128,'j',5);
insert into h values(-679411712,'k','u','z',-330170368,'n',6);
insert into h values(-2124218368,NULL,'r','h',155123712,NULL,7);
insert into h values(-27573,'j',NULL,'l',-1298661376,'x',8);
insert into h values(430440448,'x','o',NULL,NULL,'t',9);
insert into i values('p','x',1466368000,-7501,NULL,1,'m');
insert into i values('y','e',-1834942464,-1881538560,NULL,2,NULL);
insert into i values(NULL,'y',330104832,NULL,'x',3,'j');
insert into i values('d',NULL,643432448,406323200,NULL,4,'v');
insert into i values(NULL,'m',970588160,724762624,'n',5,'q');
insert into i values('u',NULL,22513,-510394368,'z',6,'e');
insert into i values(NULL,'q',60555264,NULL,NULL,7,NULL);
insert into i values('z','d',NULL,126156800,NULL,8,'y');
insert into i values(NULL,'q',-1624440832,1150,'v',9,'l');
insert into i values('o','q',1193541632,552468480,'c',10,'o');
CREATE INDEX [col_int_key_idx] ON [k] ([col_int_key]);
CREATE INDEX [col_varchar_10_key_idx] ON [k] ([col_varchar_10_key]);
CREATE INDEX [col_varchar_1024_key_idx] ON [k] ([col_varchar_1024_key]);
CREATE INDEX [col_int_key_idx] ON [h] ([col_int_key]);
CREATE INDEX [col_varchar_1024_key_idx] ON [h] ([col_varchar_1024_key]);
CREATE INDEX [col_varchar_10_key_idx] ON [h] ([col_varchar_10_key]);
CREATE INDEX [col_varchar_1024_key_idx] ON [i] ([col_varchar_1024_key]);
CREATE INDEX [col_int_key_idx] ON [i] ([col_int_key]);
CREATE INDEX [col_varchar_10_key_idx] ON [i] ([col_varchar_10_key]);

SELECT table2 . col_int AS field1 , table2 . col_int AS field2 , table1 . col_int_key AS field3 FROM k AS table1 LEFT JOIN i AS table2 ON table1 . col_varchar_1024_key = table2 . col_varchar_1024 LEFT JOIN h AS table3 ON table2 . col_varchar_10 = table3 . col_varchar_10_key LEFT JOIN i AS table4 ON table2 . col_varchar_10_key = table4 . col_varchar_1024_key WHERE table1 . pk <= table4 . col_int using index none;
SELECT table2 . col_int AS field1 , table2 . col_int AS field2 , table1 . col_int_key AS field3 FROM k AS table1 LEFT JOIN i AS table2 ON table1 . col_varchar_1024_key = table2 . col_varchar_1024 LEFT JOIN h AS table3 ON table2 . col_varchar_10 = table3 . col_varchar_10_key LEFT JOIN i AS table4 ON table2 . col_varchar_10_key = table4 . col_varchar_1024_key WHERE table1 . pk <= table4 . col_int;

drop table i,h,k;
