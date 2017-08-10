--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
set names utf8;
create table t (col1 varchar(10) collate utf8_km_exp DEFAULT NULL, col2 varchar(10) collate utf8_km_exp); 
INSERT INTO t  VALUES('ក', UPPER(' ', 'ក'));
INSERT INTO t  VALUES('ខ', UPPER(' ', 'ខ'));
INSERT INTO t  VALUES('គ', UPPER(' ', 'គ'));
INSERT INTO t  VALUES('ឃ', UPPER(' ', 'ឃ'));
INSERT INTO t  VALUES('ង', UPPER(' ', 'ង'));
INSERT INTO t  VALUES('ច', UPPER(' ', 'ច'));
              
INSERT INTO t  VALUES('ញ', UPPER(' ', 'ញ'));
INSERT INTO t  VALUES('ដ', UPPER(' ', 'ដ'));
INSERT INTO t  VALUES('ណ', UPPER(' ', 'ណ'));
INSERT INTO t  VALUES('ត', UPPER(' ', 'ត'));
INSERT INTO t  VALUES('ន', UPPER(' ', 'ន'));
INSERT INTO t  VALUES('ប', UPPER(' ', 'ប'));
INSERT INTO t  VALUES('ម', UPPER(' ', 'ម'));
              
INSERT INTO t  VALUES('យ', UPPER(' ', 'យ'));
INSERT INTO t  VALUES('ឝ', UPPER(' ', 'ឝ'));
INSERT INTO t  VALUES('ឞ', UPPER(' ', 'ឞ'));
INSERT INTO t  VALUES('អ', UPPER(' ', 'អ'));
INSERT INTO t  VALUES('ហ្គ', UPPER(' ', 'ហ្គ'));
INSERT INTO t  VALUES('ហ្ម', UPPER(' ', 'ហ្ម'));
INSERT INTO t  VALUES('០', UPPER(' ', '០'));
INSERT INTO t  VALUES('១', UPPER(' ', '១'));
INSERT INTO t  VALUES('២', UPPER(' ', '២'));
INSERT INTO t  VALUES('៣',UPPER(' ', '៣'));
INSERT INTO t  VALUES('៤',UPPER(' ', '៤'));
INSERT INTO t  VALUES('៥',UPPER(' ', '៥'));
INSERT INTO t  VALUES('៦',UPPER(' ', '៦'));
INSERT INTO t  VALUES('៧',UPPER(' ', '៧'));
INSERT INTO t  VALUES('៨',UPPER(' ', '៨'));
INSERT INTO t  VALUES('៩',UPPER(' ', '៩'));


create index idx on t (col1, col2); 

--test
select /*+ recompile */* from t order by col1; 
--test
select /*+ recompile */* from t using index none order by col1 desc; 

drop t;
set names iso88591;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

