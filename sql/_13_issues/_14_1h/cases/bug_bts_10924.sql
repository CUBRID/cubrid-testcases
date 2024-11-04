drop table if exists that1;
drop table if exists that2;
drop table if exists that3;
drop table if exists that4;
drop table if exists that5;
drop table if exists that6;
drop table if exists that7;
drop table if exists that8;
drop table if exists that9;
drop table if exists that_d;
drop table if exists that_10;
drop table if exists that_11;
drop table if exists that_12;
drop table if exists that_13;
drop table if exists that_14;
drop table if exists that_15;
drop table if exists that_16;
drop table if exists that_de;
drop table if exists that_17;
drop table if exists that_18;
drop table if exists that_19;
drop table if exists that_20;
drop table if exists that_dt;
drop table if exists that_21;
drop table if exists that_22;
drop table if exists that_23;
drop table if exists that_24;
drop table if exists that_25;
drop table if exists that_26;
drop table if exists that_27;
drop table if exists that_28;
drop table if exists that_29;
drop table if exists that_30;
drop table if exists that_31;
drop table if exists that_32;
drop table if exists that_33;
drop table if exists that_34;
drop table if exists that_35;
drop table if exists that_36;
drop table if exists that_37;
drop table if exists that_38;
drop table if exists that_39;
drop table if exists that_40;
drop table if exists that_41;
drop table if exists that_42;
drop table if exists that_43;
drop table if exists that_pat;
drop table if exists that_45;
drop table if exists that_46;
drop table if exists that_47;
drop table if exists that_48;
drop table if exists that_ahn;
drop table if exists that_49;
drop table if exists that_50;
drop table if exists that_51;
drop table if exists that_52;
drop table if exists that_53;
drop table if exists that_o;
drop table if exists that_ou;
drop table if exists that_54;
drop table if exists that_55;
drop table if exists that_56;
drop table if exists that_57;
drop table if exists that_58;
drop table if exists that_59;
drop table if exists that_60;
drop table if exists that_61;
CREATE TABLE "that1"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "tp" integer NOT NULL,
    "ped" integer NOT NULL,
    "e1" integer NOT NULL,
    "dwtwtp" integer NOT NULL
);

CREATE TABLE "that2"(
    "id" character(40) NOT NULL,
    "ehyped" integer,
    "ehydt1" character varying(20),
    "ehyat1" integer,
    "ehytp" integer,
    "ehyb" character varying(2),
    "ehyv" character varying(2)
);

CREATE TABLE "that3"(
    "id" character(40) NOT NULL,
    "dan" character varying(1536),
    "ativh" character varying(20),
    "htivh" character varying(20),
    "gktp" integer DEFAULT 1 NOT NULL
);

CREATE TABLE "that4"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "gid" integer NOT NULL,
    "ativh" character varying(20),
    "atwth" integer NOT NULL
);

CREATE TABLE "that5"(
    "id" character(40) NOT NULL,
    "titsh" character varying(384) NOT NULL,
    "nmt1" character varying(4000),
    "bnmt1" integer DEFAULT 0 NOT NULL,
    "oid" character varying(20),
    "gpid" integer,
    "ntivh" character varying(20),
    "tp" integer NOT NULL
);

CREATE TABLE "that6"(
    "id" character(40) NOT NULL,
    "lid" character(40) NOT NULL,
    "fid" integer NOT NULL,
    "jeumv" character varying(384) NOT NULL,
    "fptb" character varying(1024) NOT NULL,
    "fac" double,
    "ntivh" character varying(20)
);

CREATE TABLE "that7"(
    "id" character(40) NOT NULL,
    "lid" character(40) NOT NULL,
    "nmt1" character varying(384) NOT NULL,
    "oid" character varying(20),
    "ntivh" character varying(20)
);

CREATE TABLE "that8"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "vptb" character varying(1024) NOT NULL,
    "vip" character varying(128),
    "vpjet" integer,
    "vpetn" integer NOT NULL,
    "atwth" integer
);

CREATE TABLE "that9"(
    "id" character varying(20) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pid" character varying(20),
    "pet" integer NOT NULL,
    "atwth" integer NOT NULL,
    "of" integer NOT NULL
);

CREATE TABLE "that_d"(
    "id" character(40) NOT NULL,
    "dtpid" integer NOT NULL,
    "titsh" character varying(384) NOT NULL,
    "bnmt1" integer NOT NULL,
    "yvwq1" integer NOT NULL,
    "yvim1" integer NOT NULL,
    "oid" character varying(20) NOT NULL,
    "oahemv" character varying(75) NOT NULL,
    "dhptid" character varying(20) NOT NULL,
    "dhptmv" character varying(75) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL,
    "vuetivh" character varying(20),
    "dntivh" character varying(20),
    "ettid" integer NOT NULL,
    "htivh" character varying(20) NOT NULL,
    "dmj" character varying(20),
    "ashyhs" character varying(2) DEFAULT '99' NOT NULL,
    "edmj" character varying(20)
);

CREATE TABLE "that_10"(
    "id" character(40) NOT NULL,
    "mdid" character(40) NOT NULL,
    "did" character(40) NOT NULL
);

CREATE TABLE "that_11"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "fyid" character(40) NOT NULL,
    "did" character(40) NOT NULL
);

CREATE TABLE "that_12"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "did" character(40) NOT NULL,
    "khzdid" character(40) NOT NULL,
    "atwth" integer,
    "ntivh" character varying(20)
);

CREATE TABLE "that_13"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "did" character(40) NOT NULL,
    "khzdid" character(40) NOT NULL,
    "atwth" integer,
    "ntivh" character varying(20)
);

CREATE TABLE "that_14"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "did" character(40) NOT NULL,
    "khzdid" character(40) NOT NULL,
    "atwth" integer,
    "ntivh" character varying(20)
);

CREATE TABLE "that_15"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "did" character(40) NOT NULL,
    "khzdid" character(40) NOT NULL,
    "atwth" integer,
    "ntivh" character varying(20)
);

CREATE TABLE "that_16"(
    "id" character(40) NOT NULL,
    "mdid" character(40) NOT NULL,
    "did" character(40) NOT NULL
);

CREATE TABLE "that_de"(
    "id" character(40) NOT NULL,
    "did" character(40) NOT NULL,
    "tpid" character varying(20) NOT NULL,
    "tpe" integer NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_17"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "fsmv" character varying(45),
    "ettid" integer NOT NULL,
    "of" integer
);

CREATE TABLE "that_18"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "gkpsv" character varying(75) NOT NULL,
    "did" character(40) NOT NULL,
    "fsid" character(40) NOT NULL,
    "fsmv" character varying(384) NOT NULL,
    "fsyhe" character varying(10) NOT NULL,
    "dan" character varying(1536),
    "gid" character varying(20) NOT NULL,
    "gmv" character varying(75) NOT NULL,
    "dhptid" character varying(20) NOT NULL,
    "dhptmv" character varying(75) NOT NULL,
    "gkfswu" integer NOT NULL,
    "gktivh" character varying(20) NOT NULL,
    "ipwdde" character varying(20) NOT NULL
);

CREATE TABLE "that_19"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "gkpsv" character varying(75) NOT NULL,
    "did" character(40) NOT NULL,
    "dtitsh" character varying(384) NOT NULL,
    "dtpmv" character varying(75) NOT NULL,
    "dyhe" character varying(10) NOT NULL,
    "dan" character varying(1536),
    "gid" character varying(20) NOT NULL,
    "gmv" character varying(75) NOT NULL,
    "dhptid" character varying(20) NOT NULL,
    "dhptmv" character varying(75) NOT NULL,
    "gkfswu" integer NOT NULL,
    "gktivh" character varying(20) NOT NULL,
    "ipwdde" character varying(20) NOT NULL
);

CREATE TABLE "that_20"(
    "id" character(40) NOT NULL,
    "did" character(40) NOT NULL,
    "dtpid" integer NOT NULL,
    "titsh" character varying(384) NOT NULL,
    "bnmt1" integer NOT NULL,
    "yvwq1" integer NOT NULL,
    "yvim1" integer NOT NULL,
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL,
    "ettid" integer NOT NULL,
    "htivh" character varying(20) NOT NULL,
    "edmj" character varying(20)
);

CREATE TABLE "that_dt"(
    "id" character varying(20) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pet" integer NOT NULL,
    "of" integer NOT NULL
);

CREATE TABLE "that_21"(
    "id" character(40) NOT NULL,
    "njsmov" integer,
    "oid" character varying(20) NOT NULL,
    "atwth" integer
);

CREATE TABLE "that_22"(
    "id" character(40) NOT NULL,
    "tp" integer NOT NULL,
    "pet" integer,
    "oid" character varying(20) NOT NULL,
    "atwth" integer
);

CREATE TABLE "that_23"(
    "id" character(40) NOT NULL,
    "atfd" integer NOT NULL,
    "atgpid" integer,
    "atfdmjdh" character(40),
    "vwxpua" integer NOT NULL,
    "vwxsta" integer NOT NULL,
    "pwuhtp" integer NOT NULL,
    "oid" character varying(20) NOT NULL
);

CREATE TABLE "that_24"(
    "id" character(40) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pid" character(40),
    "pet" integer NOT NULL,
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_25"(
    "id" character varying(10) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "gpid" integer NOT NULL,
    "oid" character varying(20) NOT NULL,
    "fmj" character varying(20)
);

CREATE TABLE "that_26"(
    "id" character(40) NOT NULL,
    "fnbid" character varying(10) NOT NULL,
    "ldtp" integer NOT NULL,
    "fmj" character varying(20) NOT NULL,
    "dan" character varying(75),
    "dtivh" character varying(20),
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL,
    "htivh" character varying(20) NOT NULL
);

CREATE TABLE "that_27"(
    "id" character(40) NOT NULL,
    "fwxdid" character(40) NOT NULL,
    "fptb" character varying(1024) NOT NULL,
    "fac" double NOT NULL,
    "pet" integer NOT NULL,
    "ntivh" character varying(20) NOT NULL
);

CREATE TABLE "that_28"(
    "id" character(40) NOT NULL,
    "did" character(40) NOT NULL,
    "fsdid" integer NOT NULL,
    "fid" integer NOT NULL,
    "fac" float NOT NULL,
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "fsfj" character varying(20)
);

CREATE TABLE "that_29"(
    "id" character(40) NOT NULL,
    "did" character(40) NOT NULL,
    "fsid" character(40) NOT NULL,
    "fstpid" character varying(20),
    "bnmt1" integer NOT NULL,
    "yvwq1" integer NOT NULL,
    "yvim1" integer NOT NULL,
    "jeumv" character varying(384) NOT NULL,
    "pet" integer,
    "wntivh" character varying(20),
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_30"(
    "id" character(40) NOT NULL,
    "fsdid" character(40) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(384)
);

CREATE TABLE "that_31"(
    "id" character(40) NOT NULL,
    "fsdid" character(40) NOT NULL,
    "tpid" character varying(20) NOT NULL,
    "tpe" integer NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_32"(
    "id" character(40) NOT NULL,
    "fsdid" character(40) NOT NULL,
    "yvwq1" integer NOT NULL,
    "yvim1" integer NOT NULL,
    "njdan" character varying(75),
    "njoid" character varying(20) NOT NULL,
    "fsdhtivh" character(8) NOT NULL,
    "njdwth" character(8) NOT NULL,
    "nidwth" character(8)
);

CREATE TABLE "that_33"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "fsmv" character varying(45),
    "tp" integer NOT NULL,
    "atwth" integer DEFAULT 2 NOT NULL,
    "ytp" integer DEFAULT 0 NOT NULL
);

CREATE TABLE "that_34"(
    "id" character varying(20) NOT NULL,
    "mdid" character(40) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pet" integer NOT NULL
);

CREATE TABLE "that_35"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "taich" double NOT NULL,
    "eaich" double NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_36"(
    "id" character(40) NOT NULL,
    "nltid" integer NOT NULL,
    "fsdid" integer NOT NULL
);

CREATE TABLE "that_37"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "fsdid" integer NOT NULL,
    "pet" integer NOT NULL
);

CREATE TABLE "that_38"(
    "fteid" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "did" character(40) NOT NULL,
    "dtitsh" character varying(384) NOT NULL,
    "fptb" character varying(2048),
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "odtivh" character varying(20) NOT NULL,
    "wns" character varying(2048),
    "odfswu" character(1),
    "qfswu" character(1)
);

CREATE TABLE "that_39"(
    "fteid" character(40)
);

CREATE TABLE "that_40"(
    "id" character varying(20) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "of" integer NOT NULL,
    "gpid" integer
);

CREATE TABLE "that_41"(
    "id" character(40) NOT NULL,
    "dgjed" character varying(75) NOT NULL,
    "nnjdh" character(3) NOT NULL
);

CREATE TABLE "that_42"(
    "id" character(40) NOT NULL,
    "mv" character varying(150) NOT NULL,
    "dan" character varying(150),
    "dtpid" integer,
    "njdh" character varying(20),
    "pid" character(40),
    "pet" integer NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL,
    "tp" integer NOT NULL,
    "pefzm" character(1) DEFAULT 'N' NOT NULL,
    "peftp" integer DEFAULT 0 NOT NULL
);

CREATE TABLE "that_43"(
    "id" character(40) NOT NULL,
    "mdid" character(40) NOT NULL,
    "tpid" character varying(20) NOT NULL,
    "tpe" integer NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_pat"(
    "id" character varying(20) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pet" integer NOT NULL,
    "of" integer NOT NULL
);

CREATE TABLE "that_45"(
    "id" character(40) NOT NULL,
    "gpid" numeric(3,0) NOT NULL,
    "did" character(40) NOT NULL,
    "edid" character varying(20) NOT NULL,
    "abtivh" character varying(20) NOT NULL,
    "abdan" character varying(150),
    "abped" character(18),
    "aboid" character varying(20) NOT NULL,
    "htivh" character(8) NOT NULL
);

CREATE TABLE "that_46"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "did" character(40) NOT NULL,
    "fsdid" character(40),
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL
);

CREATE TABLE "that_47"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "ped" integer NOT NULL,
    "of" integer
);

CREATE TABLE "that_48"(
    "id" integer NOT NULL,
    "gpid" integer NOT NULL,
    "vwxpua" integer NOT NULL,
    "aidhtp" integer NOT NULL,
    "lita" integer NOT NULL,
    "njsje" integer NOT NULL,
    "xest" integer NOT NULL,
    "zest" integer NOT NULL,
    "xpat" double NOT NULL,
    "zpat" double NOT NULL,
    "pgid1" double NOT NULL,
    "pbit1" double NOT NULL
);

CREATE TABLE "that_ahn"(
    "id" character varying(20) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pet" integer NOT NULL,
    "of" integer NOT NULL
);

CREATE TABLE "that_49"(
    "id" character(40) NOT NULL,
    "ipwdde" character varying(128) NOT NULL,
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_50"(
    "id" character(40) NOT NULL,
    "ipwdde" character varying(128) NOT NULL,
    "dan" character varying(1536),
    "oid" character varying(20) NOT NULL,
    "oahemv" character varying(75) NOT NULL,
    "gid" character varying(20) NOT NULL,
    "gmv" character varying(75) NOT NULL,
    "gkfswu" integer NOT NULL,
    "gktivh" character varying(20) NOT NULL
);

CREATE TABLE "that_51"(
    "id" character(40) NOT NULL,
    "tlsmv" character varying(75) NOT NULL,
    "dan" character varying(1536),
    "gid" character varying(20) NOT NULL,
    "gmv" character varying(75) NOT NULL,
    "gkfswu" integer NOT NULL,
    "gktivh" character varying(20) NOT NULL,
    "ipwdde" character varying(20) NOT NULL
);

CREATE TABLE "that_52"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "shm" integer NOT NULL,
    "oratwth" integer NOT NULL,
    "imatwth" integer NOT NULL,
    "moatwth" integer NOT NULL,
    "format" character varying(75),
    "atwth" integer NOT NULL,
    "anb" character(1) DEFAULT 'Y' NOT NULL
);

CREATE TABLE "that_53"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "tuid" integer NOT NULL,
    "pet" integer NOT NULL
);

CREATE TABLE "that_o"(
    "id" character varying(20) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pwaagd" character(40) NOT NULL,
    "dhptid" character varying(20) NOT NULL,
    "ahnid" character varying(20) NOT NULL,
    "patid" character varying(20) NOT NULL,
    "doid1" character varying(20) NOT NULL,
    "of" integer NOT NULL,
    "awlom" character varying(20),
    "baid1" character(40),
    "iawpe" character(1) DEFAULT 'Y'
);

CREATE TABLE "that_ou"(
    "id" character(40) NOT NULL,
    "upid1" character varying(20) NOT NULL,
    "oid" character varying(20) NOT NULL
);

CREATE TABLE "that_54"(
    "id" character(40) NOT NULL,
    "fsid" character(40) NOT NULL,
    "fsdid" integer NOT NULL,
    "fid" integer NOT NULL,
    "jeumv" character varying(384) NOT NULL,
    "fptb" character varying(1024) NOT NULL,
    "fac" double NOT NULL,
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer,
    "fsfj" character varying(20)
);

CREATE TABLE "that_55"(
    "id" character(40) NOT NULL,
    "mdid" character(40) NOT NULL,
    "glfid" character(40) NOT NULL
);

CREATE TABLE "that_56"(
    "id" integer NOT NULL,
    "taich" double NOT NULL,
    "eaich" double NOT NULL,
    "oid" character varying(20) NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_57"(
    "id" character(40) NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "pid" character(40),
    "pet" integer NOT NULL,
    "oid" character varying(20) NOT NULL,
    "ntivh" character varying(20) NOT NULL,
    "atwth" integer NOT NULL
);

CREATE TABLE "that_58"(
    "id" integer NOT NULL,
    "mv" character varying(75) NOT NULL,
    "dan" character varying(150),
    "atwth" integer NOT NULL,
    "tp" integer NOT NULL,
    "jpt" character varying(20) NOT NULL,
    "psinz" character varying(20) NOT NULL,
    "dhptzm" character(1) DEFAULT '0',
    "pet" integer DEFAULT 1 NOT NULL,
    "wdebt" integer DEFAULT 0 NOT NULL
);

CREATE TABLE "that_59"(
    "gpid" integer NOT NULL,
    "qjltp" integer DEFAULT 0 NOT NULL,
    "upeosh" integer DEFAULT 0 NOT NULL,
    "upjmh" integer NOT NULL,
    "upjmt" integer NOT NULL,
    "mdeosh" integer NOT NULL,
    "mddtp" integer NOT NULL,
    "eeosh" integer NOT NULL,
    "ativh" character(19),
    "htivh" character(19),
    "hn1" character varying(10),
    "hva" character varying(1024),
    "atwth" integer DEFAULT 1 NOT NULL,
    "qls1" integer DEFAULT 0 NOT NULL,
    "eiubta" integer DEFAULT 0
);

CREATE TABLE "that_60"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "dtpid" integer NOT NULL,
    "ettid" integer NOT NULL
);

CREATE TABLE "that_61"(
    "id" character(40) NOT NULL,
    "gpid" integer NOT NULL,
    "tpid" character varying(20) NOT NULL,
    "tpe" integer NOT NULL,
    "atwth" integer NOT NULL
);

prepare st from 'SELECT COUNT(*) AS CNT FROM that_d D , (SELECT DID FROM that_de DR WHERE 1 = 1 AND ( (ATWTH = 1 AND tpID IN (SELECT upid1 FROM that_ou WHERE OID = ?) ) OR (ATWTH = 2 AND tpID IN (SELECT ID FROM 

                THAT_AHN WHERE PET >= (SELECT PET FROM that_o U, THAT_AHN S WHERE U.AHNID = S.ID AND U.ID = ?)) ) OR (ATWTH = 3 AND tpID IN (SELECT ID FROM THAT_PAT WHERE PET >= (SELECT PET FROM that_o U, THAT_PAT P 

                    WHERE U.PATID = P.ID AND U.ID = ?)) ) OR (ATWTH = 4 AND tpID IN (SELECT ID FROM that_dt WHERE PET >= (SELECT PET FROM that_o U, that_dt D WHERE U.doid1 = D.ID AND U.ID = ?)) ) OR (ATWTH = 5 AND tpID = ?) ) AND tpe 

    > 0) T WHERE 1 = 1 AND D.ID = T.DID AND ATWTH IN (?, ?) AND NTIVH >= ? AND NTIVH <= ?';

execute st using 'testadmin',
'testadmin', 'testadmin', 'testadmin', 'testadmin', 1, 2, '2013-01-01',
'2013-03-25 23:59:59';
deallocate prepare st;

drop table if exists that1;
drop table if exists that2;
drop table if exists that3;
drop table if exists that4;
drop table if exists that5;
drop table if exists that6;
drop table if exists that7;
drop table if exists that8;
drop table if exists that9;
drop table if exists that_d;
drop table if exists that_10;
drop table if exists that_11;
drop table if exists that_12;
drop table if exists that_13;
drop table if exists that_14;
drop table if exists that_15;
drop table if exists that_16;
drop table if exists that_de;
drop table if exists that_17;
drop table if exists that_18;
drop table if exists that_19;
drop table if exists that_20;
drop table if exists that_dt;
drop table if exists that_21;
drop table if exists that_22;
drop table if exists that_23;
drop table if exists that_24;
drop table if exists that_25;
drop table if exists that_26;
drop table if exists that_27;
drop table if exists that_28;
drop table if exists that_29;
drop table if exists that_30;
drop table if exists that_31;
drop table if exists that_32;
drop table if exists that_33;
drop table if exists that_34;
drop table if exists that_35;
drop table if exists that_36;
drop table if exists that_37;
drop table if exists that_38;
drop table if exists that_39;
drop table if exists that_40;
drop table if exists that_41;
drop table if exists that_42;
drop table if exists that_43;
drop table if exists that_pat;
drop table if exists that_45;
drop table if exists that_46;
drop table if exists that_47;
drop table if exists that_48;
drop table if exists that_ahn;
drop table if exists that_49;
drop table if exists that_50;
drop table if exists that_51;
drop table if exists that_52;
drop table if exists that_53;
drop table if exists that_o;
drop table if exists that_ou;
drop table if exists that_54;
drop table if exists that_55;
drop table if exists that_56;
drop table if exists that_57;
drop table if exists that_58;
drop table if exists that_59;
drop table if exists that_60;
drop table if exists that_61;
