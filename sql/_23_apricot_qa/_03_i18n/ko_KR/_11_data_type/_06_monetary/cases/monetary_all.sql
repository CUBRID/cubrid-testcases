CREATE TABLE t1 (m1 monetary);
INSERT INTO t1 VALUES ($1);
INSERT INTO t1 VALUES ($-1);
INSERT INTO t1 VALUES (\2);
INSERT INTO t1 VALUES (\-2);
INSERT INTO t1 VALUES (\TL3);
INSERT INTO t1 VALUES (\TL-3);
INSERT INTO t1 VALUES (\JPY4);
INSERT INTO t1 VALUES (\JPY-4);
INSERT INTO t1 VALUES (\KRW5);
INSERT INTO t1 VALUES (\KRW-5);
INSERT INTO t1 VALUES (\TRY123456789012345678901234567890123456789012345678901234567890);

INSERT INTO t1 VALUES (\KHR6);
INSERT INTO t1 VALUES (\KHR-6);

INSERT INTO t1 VALUES (\INR7);
INSERT INTO t1 VALUES (\INR-7);

INSERT INTO t1 VALUES (\RUB8);
INSERT INTO t1 VALUES (\RUB-8);

INSERT INTO t1 VALUES (\AUD9);
INSERT INTO t1 VALUES (\AUD-9);

INSERT INTO t1 VALUES (\CAD10);
INSERT INTO t1 VALUES (\CAD-10);

INSERT INTO t1 VALUES (\BRL11);
INSERT INTO t1 VALUES (\BRL-11);

INSERT INTO t1 VALUES (\RON12);
INSERT INTO t1 VALUES (\RON-12);

INSERT INTO t1 VALUES (\EUR13);
INSERT INTO t1 VALUES (\EUR-13);

INSERT INTO t1 VALUES (\CHF14);
INSERT INTO t1 VALUES (\CHF-14);

INSERT INTO t1 VALUES (\DKK15);
INSERT INTO t1 VALUES (\DKK-15);

INSERT INTO t1 VALUES (\NOK16);
INSERT INTO t1 VALUES (\NOK-16);

INSERT INTO t1 VALUES (\BGN17);
INSERT INTO t1 VALUES (\BGN-17);

INSERT INTO t1 VALUES (\USD18);
INSERT INTO t1 VALUES (\USD-18);

INSERT INTO t1 VALUES (\GBP19);
INSERT INTO t1 VALUES (\GBP-19);

INSERT INTO t1 VALUES (\VND20);
INSERT INTO t1 VALUES (\VND-20);

INSERT INTO t1 VALUES (\CZK21);
INSERT INTO t1 VALUES (\CZK-21);

INSERT INTO t1 VALUES (\PLN22);
INSERT INTO t1 VALUES (\PLN-22);

INSERT INTO t1 VALUES (\SEK23);
INSERT INTO t1 VALUES (\SEK-24);

INSERT INTO t1 VALUES (\HRK25);
INSERT INTO t1 VALUES (\HRK-25);

INSERT INTO t1 VALUES (\RSD26);
INSERT INTO t1 VALUES (\RSD-26);

select * from t1 order by 1;

-- default values
CREATE TABLE tt1 (m1 monetary default \USD1, m1_1 monetary default \USD-1, m100 monetary default $100, m100_1 monetary default $-100, 
m2 monetary default \JPY2, m2_1 monetary default \JPY-2,
m3 monetary default \GBP3, m3_1 monetary default \GBP-3,
m4 monetary default \KRW4, m4_1 monetary default \KRW-4, m400 monetary default \400, m400_1 monetary default \-400,
m5 monetary default \TRY5, m5_1 monetary default \TRY-500, m500 monetary default \TL500, m500_1 monetary default \TL-500,
m6 monetary default \KHR6, m6_1 monetary default \KHR-6,
m7 monetary default \CNY7, m7_1 monetary default \CNY-7,
m8 monetary default \INR8, m8_1 monetary default \INR-8,
m9 monetary default \RUB9, m9_1 monetary default \RUB-9,
m10 monetary default \AUD10, m10_1 monetary default \AUD-10,
m11 monetary default \CAD11, m11_1 monetary default \CAD-11,
m12 monetary default \BRL12, m12_1 monetary default \BRL-12,
m13 monetary default \RON13, m13_1 monetary default \RON-13,
m14 monetary default \EUR14, m14_1 monetary default \EUR-14,
m15 monetary default \CHF15, m15_1 monetary default \CHF-15,
m16 monetary default \DKK16, m16_1 monetary default \DKK-16,
m17 monetary default \NOK17, m17_1 monetary default \NOK-17,
m18 monetary default \BGN18, m18_1 monetary default \BGN-18,
m19 monetary default \VND19, m19_1 monetary default \VND-19,
m20 monetary default \CZK20, m20_1 monetary default \CZK-20,
m21 monetary default \PLN21, m21_1 monetary default \PLN-21,
m22 monetary default \SEK22, m22_1 monetary default \SEK-22,
m23 monetary default \HRK23, m23_1 monetary default \HRK-23,
m24 monetary default \RSD24, m24_1 monetary default \RSD-24);
insert into tt1(m1) values(10);
select * from tt1 order by 1;
drop table t1,tt1;













