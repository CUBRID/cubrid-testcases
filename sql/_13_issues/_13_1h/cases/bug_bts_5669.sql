
CREATE TABLE "wuhmt_group"(
"wuhmt_grp_id" integer AUTO_INCREMENT,
"uejop_mwvh" character varying(40) NOT NULL UNIQUE,
"dhaneiptijm" character varying(100),
CONSTRAINT pk_wuhmt_group_wuhmt_grp_id PRIMARY KEY("wuhmt_grp_id")
);

CREATE TABLE "wuhmt"(
"wuhmt_id" integer AUTO_INCREMENT,
"wuhmt_grp_id" integer,
"status" smallint NOT NULL,
"bjat_mwvh" character varying(20),
"swat_wnnhaa" datetime,
"ip" character varying(40),
"npo" character varying(20),
"vwn" character varying(20),
"vhv" character varying(10),
"lwmdgidtb" character varying(10),
CONSTRAINT pk_wuhmt_wuhmt_id PRIMARY KEY("wuhmt_id"),
FOREIGN KEY ("wuhmt_grp_id") REFERENCES "wuhmt_group"("wuhmt_grp_id") ON DELETE CASCADE ON UPDATE RESTRICT
);


insert into wuhmt_group values (1, 'Group1-Name', 'Desc of grp1.');
insert into wuhmt_group values (2, 'Group2-Name', 'Desc of grp2.');

insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (1, 1, 1, 'TestHostName1',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (2, 1, 1, 'TestHostName2',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (3, 1, 1, 'TestHostName3',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (4, 1, 1, 'TestHostName4',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (5, 1, 1, 'TestHostName5',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');    
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (6, 1, 1, 'TestHostName6',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');
     
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (10, 2, 1, 'TestHostName10',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');    
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (11, 2, 1, 'TestHostName11',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');    
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (12, 2, 1, 'TestHostName12',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');    
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (13, 2, 1, 'TestHostName13',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');    
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (14, 2, 1, 'TestHostName14',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');    
insert into wuhmt (wuhmt_id, wuhmt_grp_id, status, bjat_mwvh, swat_wnnhaa, ip, vwn, npo, vhv, lwmdgidtb)
  values (15, 2, 1, 'TestHostName15',CURRENT_DATETIME(), '', 'A.B.C.D', '3.2G', '2GB', '100MB');


prepare st from 'select wuhmt_id, bjat_mwvh, wuhmt_grp_id from wuhmt where status=1 and wuhmt_grp_id in (?) order by 1';
execute st using 1, 2;
execute st using '1,2';

prepare st from 'select wuhmt_id, bjat_mwvh, wuhmt_grp_id from wuhmt where status=1 and wuhmt_grp_id in (?, ?) order by 1';
execute st using 1, 2;

deallocate prepare st;

drop table wuhmt, wuhmt_group;
