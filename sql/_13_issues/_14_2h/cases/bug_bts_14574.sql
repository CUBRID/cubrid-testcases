--scenario1:client side insert
--+ holdcas on; 
set system parameters 'insert_execution_mode=1';
drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq character(3) NOT NULL, 
        title character varying(255), 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq character(3) NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 

    INSERT INTO aa VALUES ('000', 'title'); 
    insert into aa values ('111','two record');
    insert into aa values ('111','three record');
    select * from aa order by 1;
    select * from aa_sub order by 1;

--scenario2:server side insert
set system parameters 'insert_execution_mode=3';
drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq character(3) NOT NULL, 
        title character varying(255), 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq character(3) NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 

    INSERT INTO aa VALUES ('000', 'title'); 
    insert into aa values ('111','two record');
    insert into aa values ('111','three record');
    select * from aa order by 1;
    select * from aa_sub order by 1;
--scenario3:test all kinds of insert type
set system parameters 'insert_execution_mode=31';
drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq character(3) NOT NULL, 
        title character varying(255), 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq character(3) NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 
      INSERT INTO aa select  rownum,rownum from db_root connect by  level<1000;
      select count(*) from aa_sub;
drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq character(3) NOT NULL, 
        title character varying(255), 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq character(3) NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 

    INSERT INTO aa VALUES ('000', 'title'); 
    insert into aa values ('111','two record');
    insert into aa values ('111','three record');
    select * from aa order by 1;
    select * from aa_sub order by 1;

drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq datetime NOT NULL default sys_datetime , 
        title character varying(255) default 'default values', 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq datetime NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 

    INSERT INTO aa  (pq,title) default values;
    insert into aa values ('111','two record');
    insert into aa values ('111','three record');
   

drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq character(3) NOT NULL, 
        title character varying(255), 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq character(3) NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 

    INSERT INTO aa VALUES ('000', 'title'); 
    insert into aa values ('111','two record');
    replace into aa values ('111','three record');
    select * from aa order by 1;
    select * from aa_sub order by 1;

    drop table if exists aa_sub,aa;
CREATE TABLE aa( 
        pq character(3) NOT NULL, 
        title character varying(255), 
        CONSTRAINT pk_aa_pq PRIMARY KEY(pq) 
    ); 
CREATE TABLE aa_sub( 
        pq character(3) NOT NULL, 
        hits integer, 
        CONSTRAINT pk_aa_sub_pq PRIMARY KEY(pq), 
        FOREIGN KEY (pq) REFERENCES aa(pq) ON DELETE CASCADE ON UPDATE RESTRICT 
    ); 
     
    CREATE TRIGGER insert_aa 
    AFTER INSERT ON aa 
    EXECUTE 
    insert into [aa_sub] values ([obj].[pq], 0); 

    INSERT INTO aa VALUES ('000', 'title'); 
    insert into aa values ('111','two record');
    insert into aa values ('111','three record') on duplicate key update pq='333';
       insert into aa values ('555','three record') on duplicate key update pq='666';
    select * from aa order by 1;
    select * from aa_sub order by 1;
    drop table if exists aa_sub,aa;
    set system parameters 'insert_execution_mode=3';
--+ holdcas off;
