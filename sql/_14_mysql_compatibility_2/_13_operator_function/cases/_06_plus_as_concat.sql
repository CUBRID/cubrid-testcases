--+ holdcas on;
set system parameters 'compat_mode=cubrid';
select '1' + '1' from db_root;
select 'plus ' + 'can ' + 'be ' + 'used ' + 'as ' + 'concat' from db_root;

CREATE TABLE t (col1 varchar(255), col2 varchar(255));

INSERT INTO t VALUES('1', '1');
INSERT INTO t VALUES('2', '2');
INSERT INTO t VALUES('3', '3');
INSERT INTO t VALUES('4', '4');

SELECT col1 + col2 FROM t ORDER BY col1, col2;

UPDATE t SET col1 = col1 + 1;

SELECT col1 FROM t ORDER BY col1;

set system parameters 'plus_as_concat=no';

SELECT col1 + col2 FROM t ORDER BY col1, col2;

UPDATE t SET col1 = col1 + 1;

SELECT col1 FROM t ORDER BY col1;

DROP TABLE t;

--test if setting mysql_mode sets plus_as_concat to no
set system parameters 'plus_as_concat = yes';

SELECT IF ('1' + '1' = '11', 'Ok', 'Nok') FROM db_root;

set system parameters 'compat_mode = mysql';

SELECT IF ('1' + '1' = '2', 'Ok', 'Nok') FROM db_root;
set system parameters 'compat_mode = cubrid';

SELECT IF ('1' + '1' = '11', 'Ok', 'Nok') FROM db_root;

--host variables
$char, $1
SELECT IF ('1' + ? = '11', 'Ok', 'Nok') FROM db_root;

set system parameters 'plus_as_concat=no';
$char, $1
SELECT IF ('1' + ? = '2', 'Ok', 'Nok') FROM db_root;

set system parameters 'plus_as_concat=yes';
commit;
--+ holdcas off;

