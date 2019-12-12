SELECT if (date'2010-01-02' - date'2010-01-01' = 1, 'ok', 'nok') FROM db_root;

SELECT if (datetime'2010-01-01 00:00:00.001' - datetime'2010-01-01 00:00:00.000' = 1, 'ok', 'nok') FROM db_root;

SELECT if (timestamp'2010-01-01 00:00:01' - timestamp'2010-01-01 00:00:00' = 1, 'ok', 'nok') FROM db_root;

SELECT if (date'2010-01-02' - datetime'2010-01-01' = 60*60*24 * 1000, 'ok', 'nok') FROM db_root;

SELECT if ('2010-01-02' - date'2010-01-01' = 60*60*24*1000, 'ok', 'nok') FROM db_root;

SELECT if (date'2010-01-02' - '2010-01-01' = 60*60*24*1000, 'ok', 'nok') FROM db_root;

SELECT if ('2010-01-02' - datetime'2010-01-01' = 60*60*24*1000, 'ok', 'nok') FROM db_root;

SELECT if (datetime'2010-01-02' - '2010-01-01' = 60*60*24*1000, 'ok', 'nok') FROM db_root;

SELECT if ('2010-01-02' - timestamp'2010-01-01' = 60*60*24*1000, 'ok', 'nok') FROM db_root;

SELECT if (timestamp'2010-01-02' - '2010-01-01' = 60*60*24*1000, 'ok', 'nok') FROM db_root;

SELECT if (timestamp'2010-01-01 00:00:01' - time'00:00:00' = 1, 'ok', 'nok') FROM db_root;

SELECT if (time'00:00:02' - time'00:00:01' = 1, 'ok', 'nok') FROM db_root;

SELECT if ('00:00:02' - time'00:00:01' = 1, 'ok', 'nok') FROM db_root;

SELECT if (time'00:00:02' - '00:00:01' = 1, 'ok', 'nok') FROM db_root;

CREATE TABLE t (s string, d date, dt datetime, t timestamp);

INSERT INTO t VALUES('2010-01-02', '2010-01-02', '2010-01-02', '2010-01-02');

SELECT if (s - d = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (s - dt = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (s - t = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (d - s = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (dt - s = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (t - s = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (d - dt = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (d - t = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (dt - d = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (t - d = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (dt - t = 0, 'ok', 'nok') from t order by s, d, dt, t;

SELECT if (t - dt = 0, 'ok', 'nok') from t order by s, d, dt, t;

DROP TABLE t;