-- create table with bit data type and insert data with B and X

create class c_vb (vb bit (8));

INSERT INTO c_vb VALUES (B'0001');
INSERT INTO c_vb VALUES (X'c');

SELECT * FROM c_vb;

drop c_vb;