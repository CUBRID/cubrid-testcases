-- serial with cache: the values up to maxvalue stay usable, only a value past it raises the overflow

create serial ser1
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 25
NOCYCLE
CACHE 10;

-- a cache block is reserved 1..10 here
SELECT serial_next_value(ser1, 1) FROM db_root;

-- past the reserved block: the next block is clamped to maxvalue instead of failing
SELECT serial_next_value(ser1, 20) FROM db_root;

-- maxvalue itself is still handed out
SELECT serial_next_value(ser1, 4) FROM db_root;

-- [er] past maxvalue
SELECT serial_next_value(ser1, 1) FROM db_root;

select current_val, min_val, max_val, cached_num from db_serial WHERE name='ser1';

drop serial ser1;
