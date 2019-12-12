-- create class with an object attribute and insert data and then using incr and decr on two attributes

CREATE CLASS board (
id  INT, title  VARCHAR(100), content  VARCHAR(4000), read_count  INT ,edit_count INT);
INSERT INTO board VALUES (1, 'aaa', 'text...', 0,10);
INSERT INTO board VALUES (2, 'bbb', 'text...', 0,0);
INSERT INTO board VALUES (3, 'ccc', 'text...', 0,0);

SELECT content, INCR(read_count),decr(edit_count) FROM board WHERE id = 1; 

SELECT content, read_count,edit_count FROM board WHERE id = 1;


drop board;