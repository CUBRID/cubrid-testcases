--CUBRID supports , MySQL supports.
drop table if exists demo_test;
CREATE TABLE `demo_test` (
    `c1` int(11) DEFAULT 1,
    `c2` float(10) DEFAULT NULL,
    `c3` numeric(10) DEFAULT NULL,
    `c4` double DEFAULT NULL,
    `c5` smallint DEFAULT NULL,
    `c6` bigint  DEFAULT NULL,
    PRIMARY KEY (`c1`)
) ;
--CUBRID doesn't support , MySQL supports.
drop table if exists demo_test;
CREATE TABLE `demo_test` (
    `c1` int(11) DEFAULT 1,
    `c2` float(10) DEFAULT NULL,
    `c3` numeric(10) DEFAULT NULL,
    `c4` double(4,3) DEFAULT NULL,
    `c5` smallint(10) DEFAULT NULL,
    `c6` bigint(10)  DEFAULT NULL,
    PRIMARY KEY (`c1`)
) ;

drop table demo_test;

