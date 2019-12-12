--[er]test incr, decr using nested use
CREATE CLASS board (
id  INT, title  VARCHAR(100), content  VARCHAR(4000), read_count  INT ,edit_count INT);
INSERT INTO board VALUES (1, 'aaa', 'text...', 0,10);
INSERT INTO board VALUES (2, 'bbb', 'text...', 0,0);
INSERT INTO board VALUES (3, 'ccc', 'text...', 0,0);

SELECT content, INCR(decr(read_count)) FROM board WHERE id = 1;
SELECT content, decr(INCR(read_count)) FROM board WHERE id = 1;

SELECT content, INCR(incr(read_count)) FROM board WHERE id = 1;
SELECT content, decr(decr(read_count)) FROM board WHERE id = 1;

drop board;