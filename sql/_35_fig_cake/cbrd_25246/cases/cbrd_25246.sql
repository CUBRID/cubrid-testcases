-- This test case verifies the following issue: CBRD-25246.
-- Ensure that cur_pageid and volumeid columns exist in the SELECT_PAGE_INFO table
-- when the hint /*+ select_page_info */ is used in a SELECT query

drop table if exists t111;
create table t111 (col1 varchar(20), col2 varchar(20), col3 varchar(20), col4 varchar(20), col5 numeric(20,10), col6 varchar(20), col7 varchar(20), col8 varchar(20));
select /*+ select_page_info */ * from t111;

insert into t111 select rownum, 1, mod(rownum,10), lpad(to_char(mod(rownum,100)),20,'0'), mod(rownum,1000), lpad(to_char(mod(rownum,10000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0') from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 100;
select /*+ select_page_info */ * from t111;

drop table t111;  