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

drop table if exists mi_loc, mi_cond;
CREATE TABLE mi_loc (enty_key NUMERIC, mi_check_pt_rout_key_n NUMERIC, mi_check_pt_pred_key_n NUMERIC);  
CREATE TABLE mi_cond (enty_key NUMERIC, mi_chkpcond_rout_key_n NUMERIC,  mi_chkpcond_pred_key_n NUMERIC); 

insert into mi_loc values(1,1,2);
insert into mi_loc values(2,2,3);

with t ( loc_enty_key, mi_check_pt_pred_key_n, cond_enty_key, enty_key ) as (
       select loc.enty_key, loc.mi_check_pt_pred_key_n, cond.enty_key, loc2.enty_key
       from   mi_loc loc join mi_cond cond on cond.mi_chkpcond_pred_key_n = loc.enty_key
                         join mi_loc  loc2 on loc2.mi_check_pt_pred_key_n = cond.enty_key       
     ),
     r ( loc_enty_key, cond_enty_key, enty_key, lvl ) as (
       select  t.loc_enty_key, t.cond_enty_key, t.enty_key, 1
         from  t
         where t.mi_check_pt_pred_key_n = 64251705940
       union all
       select  t.loc_enty_key, t.cond_enty_key, t.enty_key, r.lvl + 1
         from  t join r on t.mi_check_pt_pred_key_n = r.cond_enty_key
     )
select   loc_enty_key, cond_enty_key, enty_key, lvl
from     r
order by lvl, loc_enty_key
;

WITH testt AS (
              SELECT  loc.enty_key loc_enty_key,
                      loc.mi_check_pt_pred_key_n,
                      cond.enty_key cond_enty_key,
                      cond.mi_chkpcond_pred_key_n
                FROM      mi_loc loc
                      LEFT JOIN
                          mi_cond cond
                        ON cond.mi_chkpcond_pred_key_n = loc.enty_key
              ),
      r(
        loc_enty_key,
        cond_enty_key,
        lvl
        ) as (
              SELECT  loc_enty_key,
                      cond_enty_key,
                      1
                FROM  testt
                WHERE mi_check_pt_pred_key_n = 64251705940
              UNION ALL
              SELECT  testt.loc_enty_key,
                      testt.cond_enty_key,
                      lvl + 1
                FROM  r,
                      testt
                WHERE r.cond_enty_key = testt.mi_check_pt_pred_key_n
            )
SELECT  r.loc_enty_key,
        r.cond_enty_key,
        loc.enty_key,
        lvl
  FROM      r
        JOIN
            mi_loc loc
          ON loc.mi_check_pt_pred_key_n = r.cond_enty_key
ORDER BY lvl,
        r.loc_enty_key;
drop table if exists mi_loc, mi_cond;
