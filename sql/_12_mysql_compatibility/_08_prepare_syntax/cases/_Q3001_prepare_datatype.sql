--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1 (id int auto_increment, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
insert into t1(a1) values ('qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab');

PREPARE stmt from 'insert into t1(a1,b2,c3,d4,e5,f6,g7,h8,i9,j10,k11,l12,m13,n14,o15,p16,q17) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'
EXECUTE STMT USING 
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null
EXECUTE STMT USING 
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null
EXECUTE stmt USING 
'qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab',
'qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab',
N'Härder',
N'Härder',
B'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
B'111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
123412435345,
3563562352412,
1341341,
1234,
123123,
3333223.01,
2341234123.3212,
2341234123.3212,
DATE '5/11/2010', 
TIME '16:08:33 pm',
TIMESTAMP '01/31/1994 8:15:00 pm'
DEALLOCATE PREPARE STMT;

select count(*) from t1 ;
select * from (select count(*) a1_count from t1 group by a1) x1 order by a1_count asc;
drop table t1;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
