--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
set system parameters 'compat_mode=mysql';

CREATE TABLE foo (bar VARCHAR(10));
INSERT INTO foo VALUES (NULL), ('a');

--TEST:bug
SELECT * FROM foo WHERE bar IS NULL OR bar LIKE '%' order by bar desc;

drop table foo;

set system parameters 'compat_mode=cubrid';
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
