--bug_bts_9027.sql
SELECT (INET_ATON('xb.0.0.1')=INET_ATON('11.0.0.1'));
SELECT (INET_ATON('0.xb.0.0')=INET_ATON('0.11.0.0'));
SELECT (INET_ATON('1.0.xb.0')=INET_ATON('1.0.11.0'));
SELECT (INET_ATON('0.1.0.xb')=INET_ATON('0.1.0.11'));

select INET_ATON('0.0.0.xb');
select INET_ATON('0.0.0.Xb');
select INET_ATON('0.0.0.XB');
select INET_ATON('0.0.0.xB');


select INET_NTOA(INET_ATON('0.0.0.11'));
select INET_NTOA(INET_ATON('0.0.0.0xb'));
select INET_NTOA(INET_ATON('0.0.0.xb'));
select INET_NTOA(INET_ATON('0.0.0.Xb'));
select INET_NTOA(INET_ATON('0.0.0.XB'));
select INET_NTOA(INET_ATON('0.0.0.xB'));
select INET_NTOA(INET_ATON('0.0.0.b'));
