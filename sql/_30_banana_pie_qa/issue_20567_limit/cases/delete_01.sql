drop if exists tab;
CREATE TABLE tab (i INT, j INT, k INT);
CREATE INDEX i_tab_j_k ON tab (j, k);
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
UPDATE STATISTICS on tab;
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  0-0-0-0-0+2,10*10;

INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);

delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  0-0-0-0-0,10*10;
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);

delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  1;
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  0;
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  0,1;

INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  0,1*6;

INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  6,1*6;
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  6-1,1*6-2;
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
delete
FROM tab
WHERE j > 0
 using index i_tab_j_k keylimit  6-1,1*6/3;
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
CREATE INDEX i_tab_j ON tab (j);
delete
FROM tab
WHERE j > 0
 using index i_tab_j(+)  keylimit  6-1,1*6/3;
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
delete
FROM tab
WHERE j > 0
 using index i_tab_j(+)  keylimit  0,6;
drop if exists tab;

