--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1 (id int auto_increment, a1 int);

PREPARE STMT from 'insert into t1(a1) values (?)'
EXECUTE stmt using 1
EXECUTE stmt USING 2
EXECUTE STMT USING 3
execute STMT Using 4
execute STMT UsinG 5
execute STMT															 UsinG 6
exeCUte 				STMT															 UsinG 7
EXECUTE STMT	UsinG 8
EXECUTE Stmt	UsinG 9
EXECUTE StMT	UsinG 10
EXECUTE	stMT	UsinG 11
DEALLOCATE PREPARE stmt;

preparE STMT from 'insert into t1(a1) values (?)'
EXECUTE stmt using 101
EXECUtE stmt USING 102
EXeCUTE STMT USING 103
execute StMT Using 104
execute STMT UsinG 105
execute STMT															 UsinG 106
exeCUte 				STMT															 UsinG 107
EXECUTE STMT	UsinG 108
eXECUTE Stmt	UsinG 109
EXECUTE StMT	UsinG 110
ExECUTE	stMT	UsinG 111
drOP PREPARE stmt;


select * from t1 order by id asc;
drop table t1;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
