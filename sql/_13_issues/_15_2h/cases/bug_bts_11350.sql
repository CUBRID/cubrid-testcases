DROP TABLE IF EXISTS `A`,`B`;
CREATE TABLE `A` (
     `id` smallint NOT NULL AUTO_INCREMENT,
     `name` varchar(80) NOT NULL,
     `method` smallint NOT NULL,
     PRIMARY KEY (`id`)
);

CREATE TABLE `B` (
     `id` mediumint  NOT NULL,
     `time` int(4) NOT NULL,
     KEY `myKey` (`time`)
) ;

INSERT INTO `A` (
    `id` ,
    `name` ,
    `method`
)
VALUES (
    NULL , 'AAA', '0'
), (
NULL , 'ZZZ', '0'
);

INSERT INTO `B` (
    `id` ,
    `time`
)
VALUES (
    '21', '1199870000'
), (
'31', '1199870083'
);

INSERT INTO `B` (
    `id` ,
    `time`
)
VALUES (
    '21', '1299870000'
), (
'31', '1299870083'
);

SELECT A.id, `name` FROM A LEFT JOIN B ON A.id=B.id AND B.`time`=(SELECT MAX(`time`) FROM B WHERE id=A.id); 

DROP TABLE A;
DROP TABLE B;
