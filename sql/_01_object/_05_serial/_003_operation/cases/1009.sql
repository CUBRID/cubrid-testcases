-- [er] serial with cache: serial_next_value(s, n) for n >= 2 past maxvalue raises the range overflow

create serial ser1
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 100
NOCYCLE
CACHE 10;

-- fill the cache
SELECT serial_next_value(ser1, 1) FROM db_root;

-- asks for a value past maxvalue: raises the error, does not hand out a value
SELECT serial_next_value(ser1, 500) FROM db_root;

-- the cached serial is still usable and keeps counting from where it was
SELECT serial_next_value(ser1, 1) FROM db_root;

select current_val, min_val, max_val, cached_num from db_serial WHERE name='ser1';

drop serial ser1;
