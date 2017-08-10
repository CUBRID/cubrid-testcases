--+ holdcas on;

set names utf8;
create table t (col1 varchar(10)  collate utf8_tr_cs not null, col2 varchar(10)  collate utf8_tr_cs); 
INSERT INTO t VALUES('a', UPPER('a'));
INSERT INTO t VALUES('b', UPPER('b'));
INSERT INTO t VALUES('c', UPPER('c'));
INSERT INTO t VALUES('d', UPPER('d'));
INSERT INTO t VALUES('e', UPPER('e'));
INSERT INTO t VALUES('f', UPPER('f'));
INSERT INTO t VALUES('g', UPPER('g'));
INSERT INTO t VALUES('h', UPPER('h'));
INSERT INTO t VALUES('j', UPPER('j'));
INSERT INTO t VALUES('k', UPPER('k'));
INSERT INTO t VALUES('l', UPPER('l'));
INSERT INTO t VALUES('m', UPPER('m'));
INSERT INTO t VALUES('n', UPPER('n'));
INSERT INTO t VALUES('o', UPPER('o'));
INSERT INTO t VALUES('p', UPPER('p'));
INSERT INTO t VALUES('r', UPPER('r'));
INSERT INTO t VALUES('s', UPPER('s'));
INSERT INTO t VALUES('t', UPPER('t'));
INSERT INTO t VALUES('u', UPPER('u'));
INSERT INTO t VALUES('v', UPPER('v'));
INSERT INTO t VALUES('y', UPPER('y'));
INSERT INTO t VALUES('z', UPPER('z'));
-- TR chars               
INSERT INTO t VALUES('ç', UPPER('ç'));
INSERT INTO t VALUES('ğ', UPPER('ğ'));
INSERT INTO t VALUES('ı', UPPER('ı'));
INSERT INTO t VALUES('i', UPPER('i'));
INSERT INTO t VALUES('ö', UPPER('ö'));
INSERT INTO t VALUES('ş', UPPER('ş'));
INSERT INTO t VALUES('ü', UPPER('ü'));
-- Non TR chars           
INSERT INTO t VALUES('q', UPPER('q'));
INSERT INTO t VALUES('x', UPPER('x'));
INSERT INTO t VALUES('w', UPPER('w'));
create idx index on t (col1, col2); 

--test
select * from t order by col1; 
--test
select * from t using index none order by col1 desc; 

drop t;
set names iso88591;

commit;
--+ holdcas off;


