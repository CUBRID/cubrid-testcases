set @a = 1;

SELECT 
    (SELECT @a := @a + 1 FROM db_root ORDER BY @a + 1), 
    (SELECT @a := @a + 1 FROM db_root ORDER BY @a + 1) 
;

SELECT 
    (SELECT @a := @a + 1 FROM db_root ORDER BY @a + 1), 
    (SELECT @a := @a - 1 FROM db_root ORDER BY @a - 1) 
;

drop variable @a;
