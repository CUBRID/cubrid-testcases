drop if exists tab;
CREATE TABLE tab (i INT, j INT, k INT);
CREATE INDEX i_tab_j_k ON tab (j, k);
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
UPDATE STATISTICS on tab;
update tab set k=918
WHERE j > 0;

update tab set k=917
WHERE j > 0
 using index i_tab_j_k keylimit  0-0-0-0-0+2,10*10;
select * from tab;

update tab set k=916
WHERE j > 0
 using index i_tab_j_k keylimit  0-0-0-0-0,10*10;
select * from tab;

update tab set k=915
WHERE j > 0
 using index i_tab_j_k keylimit  1;
select * from tab;

update tab set k=914
WHERE j > 0
 using index i_tab_j_k keylimit  0;
select * from tab;

update tab set k=98
WHERE j > 0
 using index i_tab_j_k keylimit  0,1;
select * from tab;

update tab set k=97
WHERE j > 0
 using index i_tab_j_k keylimit  0,1*6;
select * from tab;

update tab set k=96
WHERE j > 0
 using index i_tab_j_k keylimit  6,1*6;
select * from tab;

update tab set k=95
WHERE j > 0
 using index i_tab_j_k keylimit  6-1,1*6-2;
select * from tab;

update tab set k=94
WHERE j > 0
 using index i_tab_j_k keylimit  6-1,1*6/3;
select * from tab;

CREATE INDEX i_tab_j ON tab (j);
update tab set k=92
WHERE j > 0
 using index i_tab_j(+)  keylimit  6-1,1*6/3;
select * from tab;

update tab set k=91
WHERE j > 0
 using index i_tab_j(+)  keylimit  0,6;
select * from tab;
drop if exists tab;

