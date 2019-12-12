create table e (
       col_int_key integer,
       col_varchar_10_key character varying(10) ,
       col_int integer,
       col_varchar_1024 character varying(1024) ,
       pk integer primary key,
       col_varchar_10 character varying(10) ,
       col_varchar_1024_key character varying(1024) );

create table f(
       pk integer primary key,
       col_int_key integer,
       col_varchar_10 character varying(10) ,
       col_varchar_10_key character varying(10) ,
       col_varchar_1024 character varying(1024) ,
       col_varchar_1024_key character varying(1024) ,
       col_int integer);

insert into e values(1096351744,'k',NULL,'k',1,'q','k');
insert into e values(447676416,'o',-1808990208,'q',2,'z','v');
insert into e values(1287127040,'r',115539968,NULL,3,'c','x');
insert into e values(-231342080,NULL,1987772416,'x',4,'v','q');
insert into e values(-932839424,'i',-350289920,'m',5,'w','f');
insert into e values(-15994,'x',NULL,'c',6,'a','h');
insert into f values(1,21958,'g','o','x','b',20638);
insert into f values(2,-329449472,NULL,'e',NULL,'r',NULL);
insert into f values(3,NULL,NULL,'u','p','j',-669450240);
insert into f values(4,5962,'n','p','i','z',618987520);
insert into f values(5,-853213184,'u',NULL,'q',NULL,-609353728);
insert into f values(6,85983232,'j',NULL,'l','n',543555584);
insert into f values(7,-537788416,'s','n','o','p',-2088960000);

SELECT  table1 . col_int_key AS field1 , table2 . col_int_key AS field2 FROM  e AS table1  RIGHT  JOIN f AS table2 ON  table1 . col_int =  table2 . col_int_key  WHERE table2 . col_int_key = 3 ORDER BY field1, field2 LIMIT 1 OFFSET 0;
SELECT  table1 . col_int_key AS field1 , table2 . col_int_key AS field2 FROM  e AS table1  RIGHT  JOIN f AS table2 ON  table1 . col_int =  table2 . col_int_key  WHERE table2 . col_int_key = 3 LIMIT 1 OFFSET 0;
drop table e,f;
