autocommit off;
CREATE CLASS patstudynew;
ALTER CLASS patstudynew ADD ATTRIBUTE
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
       CONSTRAINT "u_patstudynew(studyid)" UNIQUE(StudyID);
CREATE INDEX idx1 ON patstudynew (StudyKind);
CREATE INDEX idx2 ON patstudynew (PatStudyStatus);
CREATE INDEX idx3 ON patstudynew (ASPATTNO);
CREATE INDEX idx4 ON patstudynew (ASORDATE);
CREATE INDEX idx5 ON patstudynew (ASRESVYN);
CREATE INDEX idx6 ON patstudynew (ASRESVDT);
CREATE INDEX idx7 ON patstudynew (ASACPTYN);
CREATE INDEX idx8 ON patstudynew (ASACPTDT);
CREATE INDEX idx9 ON patstudynew (ASEXCTDT);
CREATE INDEX idx10 ON patstudynew (ASEXCTYN);
CREATE INDEX idx11 ON patstudynew (ASREADDT);
CREATE INDEX idx12 ON patstudynew (ASREADYN);
CREATE INDEX idx13 ON patstudynew (ASCOFMDT);
CREATE INDEX idx14 ON patstudynew (ASCOFMYN);
CREATE INDEX idx15 ON patstudynew (ASROOMCD);
CREATE INDEX idx16 ON patstudynew (ASEXDOT);
CREATE INDEX idx17 ON patstudynew (StudyName);
CREATE INDEX idx18 ON patstudynew (ClinicName);
CREATE INDEX idx19 ON patstudynew (ArchFlag);
CREATE INDEX idx20 ON patstudynew (PName);
INSERT INTO patstudynew  (StudyID, StudyKind, ASPATTNO)
       VALUES (100, 1, 'Test');
SELECT * FROM patstudynew;
ROLLBACK;
rollback;
