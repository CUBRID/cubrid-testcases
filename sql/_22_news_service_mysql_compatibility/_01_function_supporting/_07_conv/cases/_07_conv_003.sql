--test
SELECT CONCAT(LPAD(HEX((4 << 31) + (CONV(1, 2, 10) << 27) + (1 << 8) + 2), 8, 0), '_', LPAD(HEX(123), 12, 0));
--test
SELECT CONCAT( conv(conv('-1', 36, 36), 36,36), '_',conv(conv('1', 36, 36), 36,36));
--test
SELECT CONCAT( conv(conv('-1', 36, 36), 36,36), '_',conv(conv('1', 36, 36), 36,36));
--test
SELECT BIT_LENGTH(conv('-1', 36, 36));
--test
SELECT STRCMP(conv('-1', 36, 36),conv('-1', 16, 16));
--test
SELECT STRCMP(conv('1', 36, 36),conv('1', 16, 16));