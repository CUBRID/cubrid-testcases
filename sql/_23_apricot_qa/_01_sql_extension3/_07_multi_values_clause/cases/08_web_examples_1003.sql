drop table if exists films;
create table films(code varchar(20) primary key,
studio varchar(20),
did int,
date_prod date DEFAULT '2012-08-22',
kind varchar(20));
INSERT INTO films (code, studio, did, date_prod, kind)
    VALUES ('T_601', 'Yojimbo', 106, '1961-06-16', 'Drama');

INSERT INTO films VALUES
    ('UA502', 'UA', 105, DEFAULT, 'Sci-Fi'),
    ('T_602', 'Yojimbo', 106, DEFAULT, 'Drama');

SELECT f.*
  FROM films f, (VALUES('MGM', 'Horror'), ('UA', 'Sci-Fi')) AS t (studio, kind)
  WHERE f.studio = t.studio AND f.kind = t.kind order by 1;

drop table if exists films;