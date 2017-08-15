/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
insert many column at the same time
A: insert one row
B: insert into t values('a');B: insert into t values('b');B: insert into t values('c');B: insert into t values('d') ...
there is overlap

NUM_CLIENTS = 2
C1: insert into t values(2,'b');
C2: insert into t(col) select 'a' from db_class a,db_class b,db_class c;
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'b');
MC: wait until C1 ready;

C2: insert into t(id,col) values(1,'a');insert into t(id,col) values(2,'b');insert into t(id,col) values(3,'c');insert into t(id,col) values(4,'d');insert into t(id,col) values(5,'a');insert into t(id,col) values(6,'b');insert into t(id,col) values(7,'c');insert into t(id,col) values(8,'d');insert into t(id,col) values(9,'a');insert into t(id,col) values(10,'b');insert into t(id,col) values(11,'a');insert into t(id,col) values(12,'b');insert into t(id,col) values(13,'c');insert into t(id,col) values(14,'d');insert into t(id,col) values(15,'a');insert into t(id,col) values(16,'b');insert into t(id,col) values(17,'c');insert into t(id,col) values(18,'d');insert into t(id,col) values(19,'a');insert into t(id,col) values(20,'b');insert into t(id,col) values(21,'a');insert into t(id,col) values(22,'b');insert into t(id,col) values(23,'c');insert into t(id,col) values(24,'d');insert into t(id,col) values(25,'a');insert into t(id,col) values(26,'b');insert into t(id,col) values(27,'c');insert into t(id,col) values(28,'d');insert into t(id,col) values(29,'a');insert into t(id,col) values(30,'b');insert into t(id,col) values(31,'a');insert into t(id,col) values(32,'b');insert into t(id,col) values(33,'c');insert into t(id,col) values(34,'d');insert into t(id,col) values(35,'a');insert into t(id,col) values(36,'b');insert into t(id,col) values(37,'c');insert into t(id,col) values(38,'d');insert into t(id,col) values(39,'a');insert into t(id,col) values(40,'b');insert into t(id,col) values(41,'a');insert into t(id,col) values(42,'b');insert into t(id,col) values(43,'c');insert into t(id,col) values(44,'d');insert into t(id,col) values(45,'a');insert into t(id,col) values(46,'b');insert into t(id,col) values(47,'c');insert into t(id,col) values(48,'d');insert into t(id,col) values(49,'a');insert into t(id,col) values(50,'b');insert into t(id,col) values(51,'a');insert into t(id,col) values(52,'b');insert into t(id,col) values(53,'c');insert into t(id,col) values(54,'d');insert into t(id,col) values(55,'a');insert into t(id,col) values(56,'b');insert into t(id,col) values(57,'c');insert into t(id,col) values(58,'d');insert into t(id,col) values(59,'a');insert into t(id,col) values(60,'b');insert into t(id,col) values(61,'a');insert into t(id,col) values(62,'b');insert into t(id,col) values(63,'c');insert into t(id,col) values(64,'d');insert into t(id,col) values(65,'a');insert into t(id,col) values(66,'b');insert into t(id,col) values(67,'c');insert into t(id,col) values(68,'d');insert into t(id,col) values(69,'a');insert into t(id,col) values(70,'b');insert into t(id,col) values(71,'a');insert into t(id,col) values(72,'b');insert into t(id,col) values(73,'c');insert into t(id,col) values(74,'d');insert into t(id,col) values(75,'a');insert into t(id,col) values(76,'b');insert into t(id,col) values(77,'c');insert into t(id,col) values(78,'d');insert into t(id,col) values(79,'a');insert into t(id,col) values(80,'b');insert into t(id,col) values(81,'a');insert into t(id,col) values(82,'b');insert into t(id,col) values(83,'c');insert into t(id,col) values(84,'d');insert into t(id,col) values(85,'a');insert into t(id,col) values(86,'b');insert into t(id,col) values(87,'c');insert into t(id,col) values(88,'d');insert into t(id,col) values(89,'a');insert into t(id,col) values(90,'b');insert into t(id,col) values(91,'a');insert into t(id,col) values(92,'b');insert into t(id,col) values(93,'c');insert into t(id,col) values(94,'d');insert into t(id,col) values(95,'a');insert into t(id,col) values(96,'b');insert into t(id,col) values(97,'c');insert into t(id,col) values(98,'d');insert into t(id,col) values(99,'a');insert into t(id,col) values(100,'b');insert into t(id,col) values(101,'a');insert into t(id,col) values(102,'b');insert into t(id,col) values(103,'c');insert into t(id,col) values(104,'d');insert into t(id,col) values(105,'a');insert into t(id,col) values(106,'b');insert into t(id,col) values(107,'c');insert into t(id,col) values(108,'d');insert into t(id,col) values(109,'a');insert into t(id,col) values(110,'b');insert into t(id,col) values(111,'a');insert into t(id,col) values(112,'b');insert into t(id,col) values(113,'c');insert into t(id,col) values(114,'d');insert into t(id,col) values(115,'a');insert into t(id,col) values(116,'b');insert into t(id,col) values(117,'c');insert into t(id,col) values(118,'d');insert into t(id,col) values(119,'a');insert into t(id,col) values(120,'b');insert into t(id,col) values(121,'a');insert into t(id,col) values(122,'b');insert into t(id,col) values(123,'c');insert into t(id,col) values(124,'d');insert into t(id,col) values(125,'a');insert into t(id,col) values(126,'b');insert into t(id,col) values(127,'c');insert into t(id,col) values(128,'d');insert into t(id,col) values(129,'a');insert into t(id,col) values(130,'b');insert into t(id,col) values(131,'a');insert into t(id,col) values(132,'b');insert into t(id,col) values(133,'c');insert into t(id,col) values(134,'d');insert into t(id,col) values(135,'a');insert into t(id,col) values(136,'b');insert into t(id,col) values(137,'c');insert into t(id,col) values(138,'d');insert into t(id,col) values(139,'a');insert into t(id,col) values(140,'b');insert into t(id,col) values(141,'a');insert into t(id,col) values(142,'b');insert into t(id,col) values(143,'c');insert into t(id,col) values(144,'d');insert into t(id,col) values(145,'a');insert into t(id,col) values(146,'b');insert into t(id,col) values(147,'c');insert into t(id,col) values(148,'d');insert into t(id,col) values(149,'a');insert into t(id,col) values(150,'b');insert into t(id,col) values(151,'a');insert into t(id,col) values(152,'b');insert into t(id,col) values(153,'c');insert into t(id,col) values(154,'d');insert into t(id,col) values(155,'a');insert into t(id,col) values(156,'b');insert into t(id,col) values(157,'c');insert into t(id,col) values(158,'d');insert into t(id,col) values(159,'a');insert into t(id,col) values(160,'b');insert into t(id,col) values(161,'c');insert into t(id,col) values(162,'d');
/*MC: wait until C2 blocked;*/
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;          

/* expected values is (2,'b') */
C2: select count(col) from t where LENGTH(col)=1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

