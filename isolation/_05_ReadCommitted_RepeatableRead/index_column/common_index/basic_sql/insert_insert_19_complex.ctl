/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes
insert many column at the same time
A: insert into t values('a');A: insert into t values('b');A: insert into t values('c');A: insert into t values('d') ...
B: insert one row
there is overlap

NUM_CLIENTS = 2
C1: insert into t(col) values('a');insert into t('b');insert into t('c');insert into t('d');insert into t('a');insert into t('b');insert into t('c');insert into t('d');insert into t('a');insert into t('b');insert into t('c');insert into t('d');insert into t('a');insert into t('b');insert into t('c');insert into t('d');insert into t('a
C2: insert into t values(2,'bbbbb');
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t(id, col) values(1,'a');
C1: insert into t(id, col) values(2,'b');
C1: insert into t(id, col) values(3,'c');
C1: insert into t(id, col) values(4,'d');
C1: insert into t(id, col) values(5,'a');
C1: insert into t(id, col) values(6,'b');
C1: insert into t(id, col) values(7,'c');
C1: insert into t(id, col) values(8,'d');
C1: insert into t(id, col) values(9,'a');
C1: insert into t(id, col) values(10,'b');
C1: insert into t(id, col) values(11,'a');
C1: insert into t(id, col) values(12,'b');
C1: insert into t(id, col) values(13,'c');
C1: insert into t(id, col) values(14,'d');
C1: insert into t(id, col) values(15,'a');
C1: insert into t(id, col) values(16,'b');
C1: insert into t(id, col) values(17,'c');
C1: insert into t(id, col) values(18,'d');
C1: insert into t(id, col) values(19,'a');
C1: insert into t(id, col) values(20,'b');
C1: insert into t(id, col) values(21,'a');
C1: insert into t(id, col) values(22,'b');
C1: insert into t(id, col) values(23,'c');
C1: insert into t(id, col) values(24,'d');
C1: insert into t(id, col) values(25,'a');
C1: insert into t(id, col) values(26,'b');
C1: insert into t(id, col) values(27,'c');
C1: insert into t(id, col) values(28,'d');
C1: insert into t(id, col) values(29,'a');
C1: insert into t(id, col) values(30,'b');
C1: insert into t(id, col) values(31,'a');
C1: insert into t(id, col) values(32,'b');
C1: insert into t(id, col) values(33,'c');
C1: insert into t(id, col) values(34,'d');
C1: insert into t(id, col) values(35,'a');
C1: insert into t(id, col) values(36,'b');
C1: insert into t(id, col) values(37,'c');
C1: insert into t(id, col) values(38,'d');
C1: insert into t(id, col) values(39,'a');
C1: insert into t(id, col) values(40,'b');
C1: insert into t(id, col) values(41,'a');
C1: insert into t(id, col) values(42,'b');
C1: insert into t(id, col) values(43,'c');
C1: insert into t(id, col) values(44,'d');
C1: insert into t(id, col) values(45,'a');
C1: insert into t(id, col) values(46,'b');
C1: insert into t(id, col) values(47,'c');
C1: insert into t(id, col) values(48,'d');
C1: insert into t(id, col) values(49,'a');
C1: insert into t(id, col) values(50,'b');
C1: insert into t(id, col) values(51,'a');
C1: insert into t(id, col) values(52,'b');
C1: insert into t(id, col) values(53,'c');
C1: insert into t(id, col) values(54,'d');
C1: insert into t(id, col) values(55,'a');
C1: insert into t(id, col) values(56,'b');
C1: insert into t(id, col) values(57,'c');
C1: insert into t(id, col) values(58,'d');
C1: insert into t(id, col) values(59,'a');
C1: insert into t(id, col) values(60,'b');
C1: insert into t(id, col) values(61,'a');
C1: insert into t(id, col) values(62,'b');
C1: insert into t(id, col) values(63,'c');
C1: insert into t(id, col) values(64,'d');
C1: insert into t(id, col) values(65,'a');
C1: insert into t(id, col) values(66,'b');
C1: insert into t(id, col) values(67,'c');
C1: insert into t(id, col) values(68,'d');
C1: insert into t(id, col) values(69,'a');
C1: insert into t(id, col) values(70,'b');
C1: insert into t(id, col) values(71,'a');
C1: insert into t(id, col) values(72,'b');
C1: insert into t(id, col) values(73,'c');
C1: insert into t(id, col) values(74,'d');
C1: insert into t(id, col) values(75,'a');
C1: insert into t(id, col) values(76,'b');
C1: insert into t(id, col) values(77,'c');
C1: insert into t(id, col) values(78,'d');
C1: insert into t(id, col) values(79,'a');
C1: insert into t(id, col) values(80,'b');
C1: insert into t(id, col) values(81,'a');
C1: insert into t(id, col) values(82,'b');
C1: insert into t(id, col) values(83,'c');
C1: insert into t(id, col) values(84,'d');
C1: insert into t(id, col) values(85,'a');
C1: insert into t(id, col) values(86,'b');
C1: insert into t(id, col) values(87,'c');
C1: insert into t(id, col) values(88,'d');
C1: insert into t(id, col) values(89,'a');
C1: insert into t(id, col) values(90,'b');
C1: insert into t(id, col) values(91,'a');
C1: insert into t(id, col) values(92,'b');
C1: insert into t(id, col) values(93,'c');
C1: insert into t(id, col) values(94,'d');
C1: insert into t(id, col) values(95,'a');
C1: insert into t(id, col) values(96,'b');
C1: insert into t(id, col) values(97,'c');
C1: insert into t(id, col) values(98,'d');
C1: insert into t(id, col) values(99,'a');
C1: insert into t(id, col) values(100,'b');
C1: insert into t(id, col) values(101,'a');
C1: insert into t(id, col) values(102,'b');
C1: insert into t(id, col) values(103,'c');
C1: insert into t(id, col) values(104,'d');
C1: insert into t(id, col) values(105,'a');
C1: insert into t(id, col) values(106,'b');
C1: insert into t(id, col) values(107,'c');
C1: insert into t(id, col) values(108,'d');
C1: insert into t(id, col) values(109,'a');
C1: insert into t(id, col) values(110,'b');
C1: insert into t(id, col) values(111,'a');
C1: insert into t(id, col) values(112,'b');
C1: insert into t(id, col) values(113,'c');
C1: insert into t(id, col) values(114,'d');
C1: insert into t(id, col) values(115,'a');
C1: insert into t(id, col) values(116,'b');
C1: insert into t(id, col) values(117,'c');
C1: insert into t(id, col) values(118,'d');
C1: insert into t(id, col) values(119,'a');
C1: insert into t(id, col) values(120,'b');
C1: insert into t(id, col) values(121,'a');
C1: insert into t(id, col) values(122,'b');
C1: insert into t(id, col) values(123,'c');
C1: insert into t(id, col) values(124,'d');
C1: insert into t(id, col) values(125,'a');
C1: insert into t(id, col) values(126,'b');
C1: insert into t(id, col) values(127,'c');
C1: insert into t(id, col) values(128,'d');
C1: insert into t(id, col) values(129,'a');
C1: insert into t(id, col) values(130,'b');
C1: insert into t(id, col) values(131,'a');
C1: insert into t(id, col) values(132,'b');
C1: insert into t(id, col) values(133,'c');
C1: insert into t(id, col) values(134,'d');
C1: insert into t(id, col) values(135,'a');
C1: insert into t(id, col) values(136,'b');
C1: insert into t(id, col) values(137,'c');
C1: insert into t(id, col) values(138,'d');
C1: insert into t(id, col) values(139,'a');
C1: insert into t(id, col) values(140,'b');
C1: insert into t(id, col) values(141,'a');
C1: insert into t(id, col) values(142,'b');
C1: insert into t(id, col) values(143,'c');
C1: insert into t(id, col) values(144,'d');
C1: insert into t(id, col) values(145,'a');
C1: insert into t(id, col) values(146,'b');
C1: insert into t(id, col) values(147,'c');
C1: insert into t(id, col) values(148,'d');
C1: insert into t(id, col) values(149,'a');
C1: insert into t(id, col) values(150,'b');
C1: insert into t(id, col) values(151,'a');
C1: insert into t(id, col) values(152,'b');
C1: insert into t(id, col) values(153,'c');
C1: insert into t(id, col) values(154,'d');
C1: insert into t(id, col) values(155,'a');
C1: insert into t(id, col) values(156,'b');
C1: insert into t(id, col) values(157,'c');
C1: insert into t(id, col) values(158,'d');
C1: insert into t(id, col) values(159,'a');
C1: insert into t(id, col) values(160,'b');
C1: insert into t(id, col) values(161,'c');
C1: insert into t(id, col) values(162,'d');
MC: wait until C1 ready;
C2: insert into t values(2,'bbbbb');
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
/* expect no value */ 
C2: select * from t where id=2;
C2: commit;          

/* expected values is (2,'b') */
C2: select * from t where id=2;
C2: commit;

C1: quit;
C2: quit;

