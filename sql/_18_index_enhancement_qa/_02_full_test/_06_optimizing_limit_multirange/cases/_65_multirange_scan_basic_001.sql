--+ holdcas on;
CREATE TABLE tab (i1 INT, i2 INT, i3 INT);

CREATE INDEX i_tab_i1_i2_i3_d  ON tab(i1, i2, i3 DESC);
CREATE INDEX i_tab_i1_i2_d ON tab(i1, i2 DESC);

INSERT INTO tab VALUES (0, 0, 0), (0, 1, 1), (0, 2, 2), (0, 3, 3), (0, 4, 4);
INSERT INTO tab VALUES (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
INSERT INTO tab VALUES (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
INSERT INTO tab VALUES (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);
INSERT INTO tab VALUES (4, 0, 40), (4, 1, 41), (4, 2, 42), (4, 3, 43), (4, 4, 44);
set system parameters 'xasl_debug_dump=yes';
set system parameters 'use_orderby_sort_limit=y';

-- queries that use the index i_tab_i1_i2_i3_d:

SELECT /*+ recompile */* FROM tab WHERE i1=2 AND i2 IN (0,1,2,3,4) AND i3 BETWEEN 0 AND 23 USING INDEX i_tab_i1_i2_i3_d(+)ORDER BY i3 DESC LIMIT 3;
SELECT /*+ recompile */* FROM tab WHERE	i1 IN (1,2,3) AND i2 = 3 USING INDEX i_tab_i1_i2_i3_d(+) ORDER BY i3 DESC LIMIT 2;
SELECT /*+ recompile */* FROM tab WHERE	i1 IN (1,2,3) USING INDEX i_tab_i1_i2_i3_d(+) ORDER BY i2 LIMIT 5;

-- queries that use the index i_tab_i1_i2_d:

SELECT /*+ recompile */* FROM tab WHERE	i1 IN (1,2,3) USING INDEX i_tab_i1_i2_d(+) ORDER BY i2 DESC LIMIT 5;
SELECT /*+ recompile */* FROM tab WHERE	i1 IN (1,2,3) AND i2 BETWEEN 0 AND 3 USING INDEX i_tab_i1_i2_d(+) ORDER BY i2 DESC LIMIT 5;
set system parameters 'xasl_debug_dump=no';
set system parameters 'use_orderby_sort_limit=n';

drop table tab;

commit;
--+ holdcas off;
