-- [er]create table with bit data type and insert data with greater X data


create class c_vb (vb bit (4));


INSERT INTO c_vb VALUES (X'c111');

SELECT * FROM c_vb;

drop c_vb;