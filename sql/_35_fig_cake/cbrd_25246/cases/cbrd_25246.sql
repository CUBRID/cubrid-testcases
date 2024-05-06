-- This test case verifies the following issue: CBRD-25246.
-- Ensure that cur_pageid and volumeid columns exist and show appropriate values in the 
-- SELECT_PAGE_INFO table when the hint /*+ select_page_info */ is used in a SELECT query

drop table if exists tbl;
create table tbl (col_a varchar(20), col_b varchar(20), col_c varchar(20), col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20));
insert into tbl select rownum, 1, mod(rownum,10), lpad(to_char(mod(rownum,100)),20,'0'), mod(rownum,1000), lpad(to_char(mod(rownum,10000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0') from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 100;

WITH tbl_data AS (
    SELECT /*+ select_page_info */ *
    FROM tbl
)
SELECT IF(p_cur_volumeid>=0,'TRUE', 'FALSE'), IF(p_cur_pageid>=0,'TRUE', 'FALSE')  FROM tbl_data;

drop table tbl;