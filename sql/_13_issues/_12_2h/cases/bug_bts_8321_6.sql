CREATE TABLE all_monetary_01 ( id int, m monetary);
INSERT INTO all_monetary_01 (id, m) VALUES (1, \TL10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (2, \KHR10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (3, \IRP10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (4, \RBL10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (5, \AUD10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (6, \CAD10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (7, \BRL10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (8, \RON10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (9, \EUR10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (10, \CHF10.15);

select id, to_char(m, 'SC999,999.99'), to_char(m, '999,999.99'), to_char(m, 'S999,999.99'), to_char(m, 'C999,999.99') from all_monetary_01 order by id;

truncate all_monetary_01;

INSERT INTO all_monetary_01 (id, m) VALUES (11, \DKK10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (12, \NOK10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (13, \BGN10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (14, \USD10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (15, \JPY10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (16, \GBP10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (17, \KRW10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (18, \VND10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (19, \CZK10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (20, \PLN10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (21, \SEK10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (22, \HRK10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (23, \RSD10.15);

select id, to_char(m, 'SC999,999.99'), to_char(m, '999,999.99'), to_char(m, 'S999,999.99'), to_char(m, 'C999,999.99') from all_monetary_01 order by id;

truncate all_monetary_01;

INSERT INTO all_monetary_01 (id, m) VALUES (25, \TL-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (26, \KHR-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (27, \INR-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (28, \RUB-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (29, \AUD-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (30, \CAD-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (31, \BRL-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (32, \RON-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (33, \EUR-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (34, \CHF-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (35, \DKK-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (36, \NOK-10.15);

select id, to_char(m, 'SC999,999.99'), to_char(m, '999,999.99'), to_char(m, 'S999,999.99'), to_char(m, 'C999,999.99') from all_monetary_01 order by id;

truncate all_monetary_01;

INSERT INTO all_monetary_01 (id, m) VALUES (37, \BGN-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (38, \USD-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (39, \JPY-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (40, \GBP-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (41, \KRW-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (42, \VND-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (43, \CZK-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (44, \PLN-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (45, \SEK-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (46, \HRK-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (47, \RSD-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (48, \&-10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (49, $10.15);
INSERT INTO all_monetary_01 (id, m) VALUES (50, $-10.15);

select id, to_char(m, 'SC999,999.99'), to_char(m, '999,999.99'), to_char(m, 'S999,999.99'), to_char(m, 'C999,999.99') from all_monetary_01 order by id;

drop all_monetary_01;
