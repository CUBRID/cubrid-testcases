-- [er]create table with bit varying data type and insert data with greater X data


create class c_vb (vb bit varying (4));


INSERT INTO c_vb VALUES (X'c111');

SELECT * FROM c_vb;

drop c_vb;