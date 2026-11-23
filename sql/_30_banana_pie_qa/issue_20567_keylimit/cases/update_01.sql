drop if exists tab;
CREATE TABLE tab (i INT, j INT, k INT);
CREATE INDEX i_tab_j_k ON tab (j, k);
INSERT INTO tab VALUES (1,2,3),(6,4,2),(3,4,1),(5,2,1),(1,5,5),(2,6,6),(3,5,4);
UPDATE STATISTICS on tab;
update tab set k=918
WHERE j > 0;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

select * from tab order by 1,2,3;

CREATE INDEX i_tab_j ON tab (j);

drop if exists tab;

