drop if exists t1;
create table t1(id int not null, parentid int,text varchar(64));

insert into t1 values(1,6,'AAAAA'), (2,6,'AAAAB'), (3,6,'AAAAC'), (4,6,'AAAAD'), (5,6,'AAAAE'), (6,31,'AAAA'), (7,12,'AAABA'), (8,12,'AAABB'), (9,12,'AAABC'), (10,12,'AAABD');
insert into t1 values(11,12,'AAABE'), (12,31,'AAAB'), (13,18,'AAACA'), (14,18,'AAACB'), (15,18,'AAACC'), (16,18,'AAACD'), (17,18,'AAACE'), (18,31,'AAAC'), (19,24,'AAADA'), (20,24,'AAADB');
insert into t1 values(21,24,'AAADC'), (22,24,'AAADD'), (23,24,'AAADE'), (24,31,'AAAD'), (25,30,'AAAEA'), (26,30,'AAAEB'), (27,30,'AAAEC'), (28,30,'AAAED'), (29,30,'AAAEE'), (30,31,'AAAE');
insert into t1 values(31,156,'AAA'), (32,37,'AABAA'), (33,37,'AABAB'), (34,37,'AABAC'), (35,37,'AABAD'), (36,37,'AABAE'), (37,62,'AABA'), (38,43,'AABBA'), (39,43,'AABBB'), (40,43,'AABBC');
insert into t1 values(41,43,'AABBD'), (42,43,'AABBE'), (43,62,'AABB'), (44,49,'AABCA'), (45,49,'AABCB'), (46,49,'AABCC'), (47,49,'AABCD'), (48,49,'AABCE'), (49,62,'AABC'), (50,55,'AABDA');
insert into t1 values(51,55,'AABDB'), (52,55,'AABDC'), (53,55,'AABDD'), (54,55,'AABDE'), (55,62,'AABD'), (56,61,'AABEA'), (57,61,'AABEB'), (58,61,'AABEC'), (59,61,'AABED'), (60,61,'AABEE');
insert into t1 values(61,62,'AABE'), (62,156,'AAB'), (63,68,'AACAA'), (64,68,'AACAB'), (65,68,'AACAC'), (66,68,'AACAD'), (67,68,'AACAE'), (68,93,'AACA'), (69,74,'AACBA'), (70,74,'AACBB');
insert into t1 values(71,74,'AACBC'), (72,74,'AACBD'), (73,74,'AACBE'), (74,93,'AACB'), (75,80,'AACCA'), (76,80,'AACCB'), (77,80,'AACCC'), (78,80,'AACCD'), (79,80,'AACCE'), (80,93,'AACC');
insert into t1 values(86,93,'AACD'), (87,92,'AACEA'), (88,92,'AACEB'), (89,92,'AACEC'), (90,92,'AACED'), (91,92,'AACEE'), (92,93,'AACE'), (93,156,'AAC'), (94,99,'AADAA'), (95,99,'AADAB');
insert into t1 values(96,99,'AADAC'), (97,99,'AADAD'), (98,99,'AADAE'), (99,124,'AADA'), (100,105,'AADBA'), (101,105,'AADBB'), (102,105,'AADBC'), (103,105,'AADBD'), (104,105,'AADBE'), (105,124,'AADB');
insert into t1 values(106,111,'AADCA'), (107,111,'AADCB'), (108,111,'AADCC'), (109,111,'AADCD'), (110,111,'AADCE'), (111,124,'AADC'), (117,124,'AADD'), (118,123,'AADEA'), (119,123,'AADEB'), (120,123,'AADEC');
insert into t1 values(121,123,'AADED'), (122,123,'AADEE'), (123,124,'AADE'), (124,156,'AAD'), (125,130,'AAEAA'), (126,130,'AAEAB'), (127,130,'AAEAC'), (128,130,'AAEAD'), (129,130,'AAEAE'), (130,155,'AAEA');
create index i_t1_id on t1(id);
create index i_t1_text on t1(text);
create index i_t1_id_text on t1(id, text);
create index i_t1_id_parentid_text on t1(id, parentid, text);

select a.id,b.id from t1 a, t1 b where a.id>10 and a.id<20 and b.id>3 using index a.i_t1_id(+) keylimit 1, 1*2, b.i_t1_id(+) keylimit 2 order by 1,2;
select a.id,b.id from t1 a, t1 b where a.id>10 and a.id<20 and a.id=b.id using index a.i_t1_id(+) keylimit 1*1+1, 4/2, b.i_t1_id(+) keylimit 1 order by 1,2;
select a.id,b.id from t1 a, t1 b where a.id>10 and a.id<20 and a.id=b.id using index a.i_t1_id(+) keylimit 1+(2*1), 2+0, b.i_t1_id(+) keylimit 0 order by 1,2;
select text from t1 where text<'ABA' using index i_t1_text(+) keylimit 45, 7 order by 1;
select id, text from t1 where id>50 and text<'BBAA' using index i_t1_id_text(+) keylimit 7 order by 1;
select id, text from t1 where id>50 and text>'A' using index i_t1_id_text(+) keylimit 7 order by 1;
select a.text,b.text from t1 a, t1 b where a.text between 'AAAAB' and 'AAAAE' and b.text between 'AACD' and 'AACEE' using index a.i_t1_text(+) keylimit 1*1,1*2 order by 1,2;
select * from t1 where id > 90 and parentid > 80 using index i_t1_id_parentid_text(+) keylimit 1*2*(10/5)+3*(1+1), 5+8/2 order by id, parentid;
select * from (select id,parentid,text from t1 where id<268 start with text='AAAA' connect by prior id=parentid using index i_t1_id_parentid_text(+) keylimit 1*3) t order by id,parentid,text;

drop table t1;
