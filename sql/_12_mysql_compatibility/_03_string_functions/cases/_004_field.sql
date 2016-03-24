SELECT FIELD('ej', 'Hej', 'ej', 'Heja', 'hej', 'foo') from db_root;

SELECT FIELD('fo', 'Hej', 'ej', 'Heja', 'hej', 'foo') from db_root;

SELECT FIELD('fo', NULL, 'ej', 'Heja', 'hej', 'foo') from db_root;

SELECT FIELD('fo', 'Hej', 2, 'Heja', 1, 'foo') from db_root;