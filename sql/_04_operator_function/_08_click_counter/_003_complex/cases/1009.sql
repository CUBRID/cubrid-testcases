--[er]test incr, decr with group by clause
CREATE CLASS board (
id  INT, title  VARCHAR(100), content  VARCHAR(4000), read_count  INT ,edit_count INT);
INSERT INTO board VALUES (1, 'aaa', 'text...', 0,10);
INSERT INTO board VALUES (2, 'bbb', 'text...', 0,0);
INSERT INTO board VALUES (3, 'ccc', 'text...', 0,0);

select incr(read_count) from board group by title;
select decr(read_count) from board group by title;

drop class board;
