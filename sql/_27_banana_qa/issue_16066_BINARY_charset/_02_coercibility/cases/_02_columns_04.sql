--+ holdcas on;
set names binary;

drop table if exists t;
create table t(i int,s string collate binary);
insert into t values(65,'a');
-- CUBRIDSUS-17854
select coercibility(collation(s)) from t;
select coercibility(substr(s,1,1)) from t;
select coercibility(chr(65)),coercibility(chr(i)) from t;

drop t;
set names iso88591;

commit;
--+ holdcas off;
