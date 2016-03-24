-- valid format
SELECT unix_timestamp('1970-01-01 09:00:00') - unix_timestamp('1970-01-01 09:00:01');

SELECT unix_timestamp('1970-01-01 09:00:00') - unix_timestamp('1970-01-01 09:00:001');

SELECT unix_timestamp('1970-01-01 09:00:00') - unix_timestamp('1970-01-01 09:00:000001.10');


-- invalid format
SELECT unix_timestamp('1970-01-01 09:00:70');

SELECT unix_timestamp('1970-01-01 09:00:00100');

SELECT unix_timestamp('1970-01-01 09:00:00000300.10');



-- another invalid format
SELECT unix_timestamp('1970-01-01 00:00:00');

SELECT unix_timestamp('1970-01-01 -1:00:00');

SELECT unix_timestamp('1970-00-01 00:00:00');

SELECT unix_timestamp('1970-01-01 00:90:00');

SELECT unix_timestamp('1970-01-01 00:00:00.abc');

SELECT unix_timestamp('1970-01-01 00:00:00.00.00');

SELECT unix_timestamp('1970-01-01 00:*:00');

