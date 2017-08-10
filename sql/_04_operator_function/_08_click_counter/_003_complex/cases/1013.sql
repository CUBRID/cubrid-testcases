--test incr, decr using it as column name
CREATE CLASS board (
id  INT, decr  VARCHAR(100), incr  VARCHAR(4000), read_count  INT ,edit_count INT);

drop class board;
