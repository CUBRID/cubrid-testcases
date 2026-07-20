DROP TABLE IF EXISTS t_cbrd_27006_ha;
CREATE TABLE t_cbrd_27006_ha
  (id INT PRIMARY KEY, single1 BIT VARYING, multi1 BIT VARYING, single2 BIT VARYING);

INSERT INTO t_cbrd_27006_ha VALUES
  (1, REPEAT(X'11', 3500), REPEAT(X'22', 20000), REPEAT(X'33', 3500));
SELECT id, LENGTH(single1) AS single1_len, LENGTH(multi1) AS multi1_len,
       LENGTH(single2) AS single2_len,
       single1 = CAST(REPEAT(X'11', 3500) AS BIT VARYING(28000)) AS single1_ok,
       multi1 = CAST(REPEAT(X'22', 20000) AS BIT VARYING(160000)) AS multi1_ok,
       single2 = CAST(REPEAT(X'33', 3500) AS BIT VARYING(28000)) AS single2_ok
  FROM t_cbrd_27006_ha ORDER BY id;

INSERT INTO t_cbrd_27006_ha VALUES
  (2, REPEAT(X'44', 3600), REPEAT(X'55', 21000), REPEAT(X'66', 3400));
SELECT id, LENGTH(single1) AS single1_len, LENGTH(multi1) AS multi1_len,
       LENGTH(single2) AS single2_len,
       single1 = CAST(CASE id WHEN 1 THEN REPEAT(X'11', 3500) ELSE REPEAT(X'44', 3600) END
                      AS BIT VARYING(28800)) AS single1_ok,
       multi1 = CAST(CASE id WHEN 1 THEN REPEAT(X'22', 20000) ELSE REPEAT(X'55', 21000) END
                     AS BIT VARYING(168000)) AS multi1_ok,
       single2 = CAST(CASE id WHEN 1 THEN REPEAT(X'33', 3500) ELSE REPEAT(X'66', 3400) END
                      AS BIT VARYING(28000)) AS single2_ok
  FROM t_cbrd_27006_ha ORDER BY id;

UPDATE t_cbrd_27006_ha
   SET single1 = REPEAT(X'77', 3700),
       multi1 = REPEAT(X'88', 22000),
       single2 = REPEAT(X'99', 3300)
 WHERE id = 1;
SELECT id, LENGTH(single1) AS single1_len, LENGTH(multi1) AS multi1_len,
       LENGTH(single2) AS single2_len,
       single1 = CAST(CASE id WHEN 1 THEN REPEAT(X'77', 3700) ELSE REPEAT(X'44', 3600) END
                      AS BIT VARYING(29600)) AS single1_ok,
       multi1 = CAST(CASE id WHEN 1 THEN REPEAT(X'88', 22000) ELSE REPEAT(X'55', 21000) END
                     AS BIT VARYING(176000)) AS multi1_ok,
       single2 = CAST(CASE id WHEN 1 THEN REPEAT(X'99', 3300) ELSE REPEAT(X'66', 3400) END
                      AS BIT VARYING(27200)) AS single2_ok
  FROM t_cbrd_27006_ha ORDER BY id;

DROP TABLE t_cbrd_27006_ha;
