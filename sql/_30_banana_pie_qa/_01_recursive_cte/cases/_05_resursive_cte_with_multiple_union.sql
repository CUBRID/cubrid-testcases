drop table if exists many_fields;
create table many_fields  
  (fieldz varchar(30), fieldy varchar(30)  
  ,field_x_1 int, field_x_2 int, field_x_3 int  
  ,field_a_1 int, field_a_2 int, field_a_3 int  
  ,field_y_1 int, field_y_2 int, field_y_3 int  
  ); 

insert into many_fields values('a','b',1,2,3,11,22,33,111,222,333);
 WITH T AS (SELECT * FROM many_fields WHERE FieldZ = '1' AND FieldY = '2'),  
X AS (  
SELECT Field_x_1 AS A, Field_x_2 AS B, Field_x_3 AS C, 1 AS R  
FROM T  
UNION ALL  
SELECT Field_A_1, Field_A_2, Field_A_3, 2 AS R  
FROM T  
UNION ALL  
SELECT Field_y_1, Field_y_2, Field_y_3, 3 AS R  
FROM T  
)  
SELECT A, B, C  
FROM X  
ORDER BY R;
drop table if exists many_fields; 

drop table if exists cbrd_loc, cbrd_cond;
CREATE TABLE cbrd_loc (cbrd_key NUMERIC, cbrd_check_dt_key_v1 NUMERIC, cbrd_check_dted_key_v2 NUMERIC);  
CREATE TABLE cbrd_cond (cbrd_key NUMERIC, cbrd_testdata_r_key_n NUMERIC,  cbrd_testdata_py_key_n NUMERIC); 

insert into cbrd_loc values(1,1,2);
insert into cbrd_loc values(2,2,3);

with t ( loc_cbrd_key, cbrd_check_dted_key_v2, cond_cbrd_key, cbrd_key ) as (
       select loc.cbrd_key, loc.cbrd_check_dted_key_v2, cond.cbrd_key, loc2.cbrd_key
       from   cbrd_loc loc join cbrd_cond cond on cond.cbrd_testdata_py_key_n = loc.cbrd_key
                         join cbrd_loc  loc2 on loc2.cbrd_check_dted_key_v2 = cond.cbrd_key       
     ),
     r ( loc_cbrd_key, cond_cbrd_key, cbrd_key, lvl ) as (
       select  t.loc_cbrd_key, t.cond_cbrd_key, t.cbrd_key, 1
         from  t
         where t.cbrd_check_dted_key_v2 = 64251705940
       union all
       select  t.loc_cbrd_key, t.cond_cbrd_key, t.cbrd_key, r.lvl + 1
         from  t join r on t.cbrd_check_dted_key_v2 = r.cond_cbrd_key
     )
select   loc_cbrd_key, cond_cbrd_key, cbrd_key, lvl
from     r
order by lvl, loc_cbrd_key
;

WITH testt AS (
              SELECT  loc.cbrd_key loc_cbrd_key,
                      loc.cbrd_check_dted_key_v2,
                      cond.cbrd_key cond_cbrd_key,
                      cond.cbrd_testdata_py_key_n
                FROM      cbrd_loc loc
                      LEFT JOIN
                          cbrd_cond cond
                        ON cond.cbrd_testdata_py_key_n = loc.cbrd_key
              ),
      r(
        loc_cbrd_key,
        cond_cbrd_key,
        lvl
        ) as (
              SELECT  loc_cbrd_key,
                      cond_cbrd_key,
                      1
                FROM  testt
                WHERE cbrd_check_dted_key_v2 = 64251705940
              UNION ALL
              SELECT  testt.loc_cbrd_key,
                      testt.cond_cbrd_key,
                      lvl + 1
                FROM  r,
                      testt
                WHERE r.cond_cbrd_key = testt.cbrd_check_dted_key_v2
            )
SELECT  r.loc_cbrd_key,
        r.cond_cbrd_key,
        loc.cbrd_key,
        lvl
  FROM      r
        JOIN
            cbrd_loc loc
          ON loc.cbrd_check_dted_key_v2 = r.cond_cbrd_key
ORDER BY lvl,
        r.loc_cbrd_key;
drop table if exists cbrd_loc, cbrd_cond;
