drop table if exists t2 ;

CREATE TABLE t2 (a INT);
CREATE INDEX t2_a on  t2 (a);
prepare stmt from ' select * from t2 where a in(?)';
execute stmt using 1;
--below statement will throw "ERROR: INTERNAL ERROR: Assertion 'xasl != NULL' failed."
execute stmt using 999999999999999999999999;
DEALLOCATE PREPARE stmt;

drop table if exists t2 ;
