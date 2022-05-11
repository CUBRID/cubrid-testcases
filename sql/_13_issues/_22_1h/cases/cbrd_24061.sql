DROP TABLE IF EXISTS t_date;

CREATE TABLE t_date
  (
     d_date DATETIME
  );

INSERT INTO t_date
            (d_date)
VALUES     (TO_DATETIME('20160901151212', 'YYYYMMDDHH24MISS')); 

--test1_success
SELECT to_char(nvl(d_date, ''))
FROM   t_date; 
--test2_error cubrid.msg:181 Cannot coerce value of domain "%1$s" t
SELECT to_char(nvl(d_date, ''), 'yyyymmddhh24miss')
FROM   t_date; 
--test3_success
SELECT nvl(to_char(d_date, 'yyyymmddhh24miss'),'') 
FROM t_date;

DROP TABLE t_date;
