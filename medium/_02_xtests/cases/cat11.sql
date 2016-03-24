autocommit off;
call login('dba', '') on class db_user;
create class foo11;
alter class foo11 ADD ATTRIBUTE
       StudyID integer NOT NULL,
       StudyKind smallint,
       ASPATTNO character(8),
       ASMDEPCD character(3),
       ASADMYMD timestamp,
       ASORDATE timestamp,
       ASORDNO smallint,
       ASORDSEL smallint,
       ASORDER character(1),
       ASORCODE character(9),
       ASTYPEDE character(2),
       ASPATTYP character(2),
       ASODDOT character(6),
       ASHOPEDT timestamp,
       ASHOPEDR character(6),
       ASWARD character(3),
       ASTEXT character varying(1073741823),
       ASPORTYN character(1),
       ASEMERYN character(1),
       ASRESVYN character(1),
       ASRESVDT timestamp,
       ASACPTYN character(1),
       ASACPTDT timestamp,
       ASEXCTYN character(1),
       ASEXCTDT timestamp,
       ASREADYN character(1),
       ASREADDT timestamp,
       ASCOFMDT timestamp,
       ASROOMCD character(4),
       ASDOTCD character(6),
       ASTECHCD character(6),
       ASEXDOT character(6),
       ASREDDR1 character(6),
       ASREDDR2 character(6),
       ASCONMDO character(6),
       ASMATOVR character(1),
       ASGROUP character(2),
       ASENDCD1 character(6),
       ASENDCD2 character(6),
       ASENDCD3 character(3),
       ASRACR1 character(8),
       ASRACR2 character(8),
       ASRACR3 character(8),
       ASPRTCNT smallint,
       AMORDER character(1),
       ASUSERID character(6),
       ASRESULT character varying(1073741823),
       ASCANYN character(1),
       ASCANDAT timestamp,
       ASPACSST character(1),
       ASPLSST character(1),
       ASEXAMAN character(19),
       StudyName character(48),
       ClinicName character(16),
       PName character(16),
       Sex character(1),
       Age smallint,
       TOA timestamp,
       ExamAsgTime timestamp,
       FilmCnt integer,
       InterpretedBy character(16),
       InterpretedBy1 character(16),
       Interpretation character varying(1073741823),
       Conclusion character varying(1073741823),
       NormCode character(10),
       PatStudyStatus smallint,
       MesurBase smallint,
       MesurBaseX1 smallint,
       MesurBaseY1 smallint,
       MesurBaseX2 smallint,
       MesurBaseY2 smallint,
       FormatH smallint,
       FormatV smallint,
       NumPrintGray smallint,
       NumPrintColor smallint,
       PrintGrayFmt smallint,
       PrintColorFmt smallint,
       PrtCBriCon smallint,
       PrtGBriCon smallint,
       ArchFlag smallint,
       ASCOFMYN character(1),
       CONSTRAINT "u_foo11(studyid)" UNIQUE(StudyID);
create INDEX i_foo11_studykind ON foo11 (StudyKind);
create INDEX i_foo11_patstudystatus ON foo11 (PatStudyStatus);
create INDEX i_foo11_aspattno ON foo11 (ASPATTNO);
create INDEX i_foo11_asordate ON foo11 (ASORDATE);
create INDEX i_foo11_asresvyn  ON foo11 (ASRESVYN);
create INDEX i_foo11_asresvdt ON foo11 (ASRESVDT);
create INDEX i_foo11_asacptyn ON foo11 (ASACPTYN);
create INDEX i_foo11_asacptdt ON foo11 (ASACPTDT);
create INDEX i_foo11_asexctdt ON foo11 (ASEXCTDT);
create INDEX i_foo11_asexctyn ON foo11 (ASEXCTYN);
create INDEX i_foo11_asreaddt ON foo11 (ASREADDT);
create INDEX i_foo11_asreadyn ON foo11 (ASREADYN);
create INDEX i_foo11_ascofmdt ON foo11 (ASCOFMDT);
create INDEX i_foo11_ascofmyn ON foo11 (ASCOFMYN);
create INDEX i_foo11_asroomcd  ON foo11 (ASROOMCD);
create INDEX i_foo11_asexdot ON foo11 (ASEXDOT);
create INDEX i_foo11_studyname ON foo11 (StudyName);
create INDEX i_foo11_clinicname ON foo11 (ClinicName);
create INDEX i_foo11_archflag ON foo11 (ArchFlag);
create INDEX i_foo11_pname ON foo11 (PName);
select * 
from db_attribute 
where class_name = 'foo11' 
order by attr_name, attr_type;
select * 
from db_index 
where class_name = 'foo11' 
order by index_name;
drop class foo11;
call login('dba', '') on class db_user;
rollback;
