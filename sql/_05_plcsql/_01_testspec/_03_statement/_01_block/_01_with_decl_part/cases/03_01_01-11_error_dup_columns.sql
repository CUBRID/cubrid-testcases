--+ server-message on

-- When column names are duplicated in the select list, it must be handled normally. However, it is treated as an error.

-- Verification for CBRD-25135

CREATE OR REPLACE  PROCEDURE text_prc 
AS 
    a varchar(10);
    b varchar(10);
BEGIN
   SELECT dummy x, dummy x INTO a, b  FROM dual;
   put_line('a=' || a);
   put_line('b=' || b);
END;

CALL text_prc() ;

drop procedure text_prc;


--+ server-message off
