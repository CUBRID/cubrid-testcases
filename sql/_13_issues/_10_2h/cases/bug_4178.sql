CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32),sort int);

INSERT INTO tree VALUES (1,NULL,'Kim',1);
INSERT INTO tree VALUES (2,NULL,'Moy',1);
INSERT INTO tree VALUES (3,1,'Jonas',3);
INSERT INTO tree VALUES (4,1,'Smith',3);
INSERT INTO tree VALUES (5,2,'Verma',2);
INSERT INTO tree VALUES (6,2,'Foster',2);
INSERT INTO tree VALUES (7,6,'Brown',1);

select id,mgrid,name,sort,level from tree
connect by prior id=mgrid
ORDER SIBLINGS BY sort,id;

drop table tree;


create table foo(id varchar(20), prnt_id varchar(20), sort_sord int); 

create table foo1(id varchar(20), prnt_id varchar(20), sort_sord int);

insert into foo values('COSC000011',         'COS',    13);

insert into foo values('COSC000012',         'COS',    14);

insert into foo values('COSC000013',         'COS',    15);

insert into foo values('COSC000014',         'COS',    16);

insert into foo values('COSC000015',         'COS',    17);

insert into foo values('COSC000016',         'COS',    18);

insert into foo values('COSC000017',         'COS',    19);

insert into foo values('COSC000018',         'COS',    20);

insert into foo values('COSC000019',         'COS',    21);

insert into foo values('COSC000020',         'COS',    22);

insert into foo values('COSC000021',         'COS',    23);

insert into foo values('COSC000022',         'COS',    24);

insert into foo values('COSC000023',         'COS',    25);

insert into foo values('COSC000024',         'COS',    26);

insert into foo values('COSC000025',         'COS',    27);

insert into foo values('COSC000026',         'COS',    28);

insert into foo values('COSC000027',         'COS',    29);

insert into foo values('COSC000028',         'COS',    30);

insert into foo values('COSC000029',         'COS',    31);

insert into foo values('COSC000030',         'COS',    32);

insert into foo values('COSC000031',         'COS',    33);

insert into foo values('COSC000032',         'COS',    34);

insert into foo values('COSC000033',         'COS',    35);

insert into foo values('COSC000034',         'COS',    36);

insert into foo values('COSC000035',         'COS',    37);

insert into foo values('COSC000036',         'COS',    38);

insert into foo values('COSC000037',         'COS',    39);

insert into foo values('COSC000038',         'COS',    40);

insert into foo values('COSC000039',         'COS',    41);

insert into foo values('COSC000040',         'COS',    42);

insert into foo values('COSC000041',         'COS',    43);

insert into foo values('COSC000042',         'COS',    44);

insert into foo values('COSC000043',         'COS',    45);

insert into foo values('COSC000044',         'COS',    46);

insert into foo values('COSC000045',         'COS',    47);

insert into foo values('COSC000046',         'COS',    48);

insert into foo values('COSC000047',         'COS',    49);

insert into foo values('COSC000048',         'COS',    50);

insert into foo values('COSC000049',         'COS',    51);

insert into foo values('COSC000003',         'COS',    8 );

insert into foo values('COSC000008',         'COS',    11);

insert into foo values('COSC000009',         'COS',    11);

insert into foo values('COSC000010',         'COS',    11);

insert into foo1 values('COS_000002',        'COSC000010',    2);

insert into foo1 values('COS_000001',        'COSC000010',    3);

insert into foo1 values('COS_000003',        'COSC000010',    4);

insert into foo1 values('COS_000004',        'COSC000010',    4);

insert into foo1 values('COS_000005',        'COSC000010',    5);

insert into foo1 values('COS_000007',        'COSC000010',    6);

insert into foo1 values('COS_000006',        'COSC000010',    7);

insert into foo1 values('COS_000008',        'COSC000010',    8);

insert into foo1 values('COS_000009',        'COSC000010',    8);

insert into foo1 values('COS_000010',        'COSC000010',    9);

insert into foo1 values('COS_000012',        'COSC000010',    10);

SELECT types,id,prnt_id,sort_sord,level FROM 

  (

  SELECT 'root' AS TYPES         ,

    'COS' AS ID             ,

    'COS' AS prnt_id     ,

    1 AS sort_sord              

     FROM db_root

    UNION ALL  

   SELECT 'C' AS TYPES         ,

   ID             ,

    prnt_id,      

    sort_sord                        

     FROM foo    

    UNION ALL  

   SELECT 'T' AS TYPES       ,

    ID         ,

    prnt_id   ,

    sort_sord               

     FROM foo1

 ) t

       START WITH ID            = 'COS' 

     CONNECT BY NOCYCLE PRIOR ID = prnt_id 

ORDER SIBLINGS BY sort_sord,id;

drop table foo;
drop table foo1;


create table ttt(ID varchar(10), PID varchar(15),  name varchar(15) , seq int);

insert into ttt values('A01', 'A00', 'MENU01', 3);
insert into ttt values('A02', 'A00', 'MENU02', 1);
insert into ttt values('A0101', 'A01', 'MENU0101', 2);
insert into ttt values('A0102', 'A01', 'MENU0102', 1);
insert into ttt values('A0201', 'A02', 'MENU0201', 1);
insert into ttt values('A03', 'A00', 'MENU03', 2);

SELECT 
    ID ,     PID ,     NAME,   level ,     SEQ  
FROM ttt
START WITH PID = 'A00' 
CONNECT BY PRIOR ID = PID 
ORDER SIBLINGS BY SEQ, ID;

drop table ttt;


