-- This test case verifies the following issue: CBRD-25246.
-- Ensure that cur_pageid and volumeid columns exist and show appropriate values in the 
-- SELECT_PAGE_INFO table when the hint /*+ select_page_info */ is used in a SELECT query

drop table if exists tbl;
create table tbl (col_a varchar(20), col_b varchar(20), col_c varchar(20), col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20));
insert into tbl select rownum, 1, mod(rownum,10), lpad(to_char(mod(rownum,100)),20,'0'), mod(rownum,1000), lpad(to_char(mod(rownum,10000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0') from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 100;

--- If the test fails but all query results still show ""...PASS" then simply proceed edit the answer file to match the new results.
WITH tbl_data AS (
    SELECT /*+ select_page_info */ *
    FROM tbl
    LIMIT 2
)
SELECT 
    CASE 
        WHEN p_cur_volumeid = 0 THEN 'p_cur_volumeid=0: PASS'
        ELSE 'p_cur_volumeid!=0: FAIL'
    END AS assert__p_cur_volumeid,
    CASE 
        WHEN p_cur_pageid + 1 = p_next_pageid THEN 'p_cur_pageid+1=p_next_pageid: PASS' 
        WHEN p_next_pageid = -1 THEN
            CASE 
                WHEN p_cur_pageid IS NULL THEN 'p_next_pageid=-1 & p_cur_pageid IS NULL: FAIL'
                WHEN p_next_pageid IS NULL THEN 'p_next_pageid=-1 & p_next_pageid IS NULL: FAIL'
                ELSE 'p_next_pageid=-1: PASS'
            END
        ELSE 'p_cur_pageid+1!=p_next_pageid: FAIL' 
    END AS assert__p_cur_pageid__p_next_pageid,
    CASE 
        WHEN p_cur_pageid - 1 = p_prev_pageid THEN 'p_cur_pageid-1=p_prev_pageid: PASS' 
        WHEN p_prev_pageid IS NULL THEN
            CASE 
                WHEN p_cur_pageid IS NULL THEN 'p_prev_pageid & p_cur_pageid IS NULL: FAIL'
                WHEN p_next_pageid IS NULL THEN 'p_prev_pageid & p_next_pageid IS NULL: FAIL'
                ELSE 'p_prev_pageid IS NULL: PASS'
            END
        ELSE 'p_cur_pageid-1!=p_prev_pageid: FAIL' 
    END AS assert_p_cur_pageid__p_prev_pageid
FROM tbl_data 
ORDER BY p_cur_volumeid, p_cur_pageid, p_prev_pageid, p_next_pageid;

drop table tbl;