--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE foo (bar VARCHAR(10));
INSERT INTO foo VALUES (NULL), ('a');

prepare stmt from 'SELECT /*+ recompile */ * FROM foo WHERE bar IS NOT NULL and bar LIKE ?'
execute stmt using '%'
deallocate prepare stmt;

prepare stmt from 'SELECT /*+ recompile */ * FROM foo WHERE bar IS NULL or bar LIKE ? order by bar desc'
execute stmt using '%'
deallocate prepare stmt;

prepare stmt from 'SELECT /*+ recompile */ * FROM foo WHERE bar IS NULL and bar LIKE ?'
execute stmt using '%'
deallocate prepare stmt;

drop table foo;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
