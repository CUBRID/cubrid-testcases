-- create table with bit VARYING data type and insert data with B and X

create class c_vb (vb bit VARYING (8));

INSERT INTO c_vb VALUES (B'0001');
INSERT INTO c_vb VALUES (X'c');

SELECT * FROM c_vb order by 1;

drop c_vb;
