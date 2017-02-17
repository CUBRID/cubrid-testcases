drop table if exists TEST_T;
drop table if exists TEST_K
CREATE TABLE TEST_T
(
  NR        VARCHAR(20),
  OPL_DATE  DATE,
  END_DATE  DATE
);


CREATE TABLE TEST_K
(
  NR        VARCHAR(20),
  OPL_DATE  DATE,
  REK_DATE  DATE
);
INSERT INTO test_t 
VALUES(
        '11'
       ,trunc(sysdate)
       ,trunc(sysdate)+2
      );

INSERT INTO test_t 
VALUES(  '12'
        ,trunc(sysdate)
        ,trunc(sysdate)+4
     );
    
INSERT INTO test_k 
VALUES(  '11'
        ,trunc(sysdate)+1
        ,trunc(sysdate)
      );
    
INSERT INTO test_t 
VALUES(   '12'
         ,trunc(sysdate)+3
         ,trunc(sysdate)
     );


WITH OPL AS (  Select *  
                    FROM   test_t 
                       WHERE NR = '11'  
                       AND OPL_DATE BETWEEN trunc(sysdate) AND trunc(sysdate) + 1 
                 )     
    ,REK AS (  
                SELECT *  
                FROM   test_k 
                   WHERE NR = '12'  
                   AND REK_DATE BETWEEN trunc(sysdate) AND trunc(sysdate) + 4
          )      
    SELECT *  
    FROM OPL  
    JOIN REK ON OPL.OPL_DATE = REK.REK_DATE;

drop table if exists TEST_T;
drop table if exists TEST_K;

