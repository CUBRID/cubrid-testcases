--core error

create class tbl_a ( a int);
create class tbl_b ( a int);

SELECT *
FROM
  ( SELECT *
  FROM
    ( SELECT  a as c
      FROM TBL_A
    ) AS ALIAS_A
    LEFT OUTER JOIN
    ( SELECT a a s c
      FROM
        TBL_B
    ) AS ALIAS_B
    ON
    ALIAS_A.c=ALIAS_B.c;
)
drop tbl_a, tbl_b;
drop tbl_a, tbl_b;
rollback;
