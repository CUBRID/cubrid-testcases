drop if exists tab;
CREATE TABLE tab (i INT, j INT, k INT);
CREATE INDEX i_tab_j_k ON tab (j, k);
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
UPDATE STATISTICS on tab;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k;

SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k limit 0-0-0-0-0,10*10;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k limit 0-0-0-0-0+2,10*10;

SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  0-0-0-0-0+2,10*10;

SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  0-0-0-0-0,10*10;

SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  1;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  0;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  0,1;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  0,1*6;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  6,1*6;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  6-1,1*6-2;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j_k keylimit  6-1,1*6/3;

CREATE INDEX i_tab_j ON tab (j);
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k  limit  6-1,1*6/3;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j(+)  keylimit  6-1,1*6/3;
SELECT j,k
FROM tab
WHERE j > 0
GROUP BY j,k using index i_tab_j(+)  keylimit  0,6;
drop if exists tab;

