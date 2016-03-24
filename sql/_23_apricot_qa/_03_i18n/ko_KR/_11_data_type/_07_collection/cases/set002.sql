--+ holdcas on;
set names utf8;
CREATE CLASS t1(
   col1       SET
);

INSERT INTO t1 VALUES ({'탐탕', '톤투'});
select * from t1 order by col1;

drop t1;
set names iso88591;
commit;
--+ holdcas off;