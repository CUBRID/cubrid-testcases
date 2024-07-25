-- This scenario varifies CBRD-25448 issue.
-- Issue Description:
-- This problem is a legacy error caused by not modifying the orderby_num in the select list when removing the order by clause.
-- The issue occurs when sorting by columns used in the conditions, resulting in all rownum values being 0. 
-- The purpose of these test cases is to verify that rownum values are correctly assigned when columns used in the conditions are also used in the ORDER BY clause.

DROP TABLE IF EXISTS game_tbl;

CREATE TABLE game_tbl(
host_year integer NOT NULL,
event_code integer NOT NULL,
athlete_code integer NOT NULL,
stadium_code integer NOT NULL,
nation_code character(3),
medal character(1),
game_date date);

INSERT INTO game_tbl VALUES (2004, 20116, 14666, 30121, 'ESP', 'S', '08/20/2004');
INSERT INTO game_tbl VALUES (2004, 20116, 14666, 30121, 'ESP', 'S', '08/20/2004');
INSERT INTO game_tbl VALUES (2004, 20305, 12258, 30117, 'USA', 'G', '08/28/2004');
INSERT INTO game_tbl VALUES (2004, 20315, 15304, 30126, 'CUB', 'B', '08/28/2004');
INSERT INTO game_tbl VALUES (2000, 20080, 12547, 30003, 'SVK', 'B', '09/18/2000');
INSERT INTO game_tbl VALUES (2000, 20153, 13014, 30020, 'RUS', 'B', '09/18/2000');
INSERT INTO game_tbl VALUES (1996, 20049, 13853, 30042, 'RUS', 'S', '07/27/1996');
INSERT INTO game_tbl VALUES (1996, 20053, 13082, 30042, 'CUB', 'B', '07/27/1996');

-- cases without view merge
-- Verifying orderby_num() in the main query.
SELECT /*+ RECOMPILE */ '#1', orderby_num(), host_year FROM game_tbl WHERE medal = 'B' ORDER BY medal;

-- Verifying orderby_num() in the main query when there is an additional condition on another column in the WHERE clause.
SELECT /*+ RECOMPILE */ '#2', orderby_num(), host_year FROM game_tbl WHERE medal = 'B' AND event_code >= 20000 ORDER BY medal;

-- Verifying orderby_num() in the main query with a LIMIT clause.
SELECT /*+ RECOMPILE */ '#3', orderby_num(), host_year FROM game_tbl WHERE medal = 'B' ORDER BY medal LIMIT 3;

-- Using REPLACE in the WHERE clause of the main query to check orderby_num().
SELECT /*+ RECOMPILE */ '#4', orderby_num(), host_year FROM game_tbl WHERE REPLACE(medal, ' ', '') = 'B' ORDER BY medal;

-- Using TO_CHAR in the WHERE clause of the main query to check orderby_num().
SELECT /*+ RECOMPILE */ '#5', orderby_num(), host_year FROM game_tbl WHERE TO_CHAR(medal) = 'B' ORDER BY medal;


--cases with view merge
-- Using a subquery to verify that rownum values are correctly assigned.
SELECT /*+ RECOMPILE */ '#6', ROWNUM rn, A.host_year FROM (SELECT /*+ RECOMPILE */ host_year FROM game_tbl WHERE medal = 'B' ORDER BY medal) A;

-- Using a subquery to verify that rownum values are correctly assigned when there is an additional condition on another column in the WHERE clause.
SELECT /*+ RECOMPILE */ '#7', ROWNUM rn, A.host_year FROM (SELECT /*+ RECOMPILE */ host_year FROM game_tbl WHERE medal = 'B' AND event_code >= 20000 ORDER BY medal) A;

-- Using a subquery to verify that rownum values are correctly assigned with filtering.
SELECT /*+ RECOMPILE */ '#8', ROWNUM rn, A.host_year FROM (SELECT /*+ RECOMPILE */ host_year FROM game_tbl WHERE medal = 'B' ORDER BY medal) A WHERE ROWNUM <= 3;

-- Using REPLACE in the WHERE clause of a subquery to check rownum values.
SELECT /*+ RECOMPILE */ '#9', ROWNUM rn, A.host_year FROM (SELECT /*+ RECOMPILE */ host_year FROM game_tbl WHERE REPLACE(medal, ' ', '') = 'B' ORDER BY medal) A;

-- Using TO_CHAR in the WHERE clause of a subquery to check rownum values.
SELECT /*+ RECOMPILE */ '#10', ROWNUM rn, A.host_year FROM (SELECT /*+ RECOMPILE */ host_year FROM game_tbl WHERE TO_CHAR(medal) = 'B' ORDER BY medal) A;

DROP TABLE IF EXISTS game_tbl;
