--use order by when executing left join with primary key 

CREATE TABLE T1 (
           TEST_KEY CHAR(64)      
           , T1_NAME CHAR(16)   
           , ID  INTEGER                      
           , VER CHAR(64)    
           , T1_DATE TIMESTAMP 
           , T1_ID1     INTEGER  
           , T1_ID2     INTEGER  
           , T1_DESC      VARCHAR(128)  
           ,PRIMARY KEY(TEST_KEY)
);


CREATE TABLE T2(
           ID   INTEGER           
           ,NAME CHAR(128) 
           ,PRIMARY KEY(ID,NAME)
);

INSERT INTO T2(ID,NAME) VALUES(1,'windows');
INSERT INTO T2(ID,NAME) VALUES(2,'linux');

CREATE TABLE T3
(
         TEST_TYPE INTEGER     
         ,TEST_DESC CHAR(64) 
           ,PRIMARY KEY(TEST_TYPE)
);

INSERT INTO T3(TEST_TYPE,TEST_DESC) VALUES(1,'Allowed Program/Port Template');
INSERT INTO T3(TEST_TYPE,TEST_DESC) VALUES(2,'Allowed Inbound IP/Port Template');
INSERT INTO T3(TEST_TYPE,TEST_DESC) VALUES(3,'Allowed Outgoing IP/Port Template');
INSERT INTO T3(TEST_TYPE,TEST_DESC) VALUES(4,'Allowed Process Template');
INSERT INTO T3(TEST_TYPE,TEST_DESC) VALUES(5,'Executable File Extentions Template')

CREATE TABLE T4
(
           TEST_KEY CHAR(64)                           
           ,TEST_CODE INTEGER AUTO_INCREMENT 
        ,TEST_TYPE INTEGER                           
           ,PRIMARY KEY(TEST_KEY,TEST_TYPE)
);
SELECT
A.TEST_KEY as TEST_KEY
,A.T1_NAME as T1_NAME
,A.T1_DESC as T1_DESC
,V.NAME as T1_NAME
,A.VER as VER
,B.TEST_CODE as TEST_CODE
,B.TEST_TYPE as TEST_TYPE
,C.TEST_DESC as TEST_DESC
,C.*
 FROM T1 A
 LEFT JOIN T4 B ON A.TEST_KEY = B.TEST_KEY
 LEFT JOIN T3  C ON B.TEST_TYPE = C.TEST_TYPE
 LEFT JOIN T2 V ON A.ID = V.ID
 ORDER BY TEST_TYPE desc;

drop TABLE T1 ,  T2, T3, T4;
commit;
