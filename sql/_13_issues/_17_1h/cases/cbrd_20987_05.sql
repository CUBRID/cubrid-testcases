drop if exists [dba].[tbm];
CREATE TABLE [dba].[tbm](
	[MID] int  NOT NULL,
	[MName] varchar(50) NULL,
	[PMID] int NULL,
	[SOrder] int NULL,
	[Ttip] varchar(100) NULL,
	[VText] varchar(100) NULL,
	[WPage] varchar(50) NULL,
	[FName] varchar(50) NULL);
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (1, 'Home page', NULL, 0, 'Cl home page', 'Cl home', 'frmIndex', 'home');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (2, 'Home - about carnival', 1, 10, 'About the 2010 carnival', '2010 carnival', 'frmCarnival', 'carnival');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (3, 'Home - photos', 1, 20, 'Photo gallery', 'Photo gallery', 'frmPhotos', 'photos');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (4, 'Home - fell race', 1, 30, 'Senior and junior fell races', 'Fell races', 'frmFellRace', 'fellrace');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (5, 'Home - scarecrows', 1, 40, 'Scarecrow competitio', 'Scarecrows', 'frmScarecrow', 'scarecrow');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (6, 'Home - help us', 1, 50, 'Cl organisatio', 'Help us', 'frmHelp', 'help');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (7, 'About carnival - dates and times', 2, 10, 'Cl date and times', 'Dates/times', 'frmWhe', 'carnival');
INSERT [dbo].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (8, 'About carnival - on the field', 2, 20, 'Activities on the field', 'On the field', 'frmRec', 'carnival');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (9, 'About carnival - parade', 2, 30, 'Cl parade', 'The parade', 'frmParade', 'carnival');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (10, 'About carnival - where', 2, 40, 'Where the carnival is', 'Where it happens', 'frmWhere', 'carnival');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (11, 'Photos - parade', 3, 10, 'Photos of the parade', 'Parade', 'frmPhotoParade', 'photos');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (12, 'Photos - field', 3, 20, 'Photos on the field', 'Rec', 'frmPhotoRec', 'photos');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (13, 'Photos - other', 3, 30, 'Other photos', 'Other', 'frmPhotoOther', 'photos');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (14, 'Photos - fell races', 3, 40, 'Fell race photos', 'Fell race', 'frmPhotoFellRace', 'photos');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (15, 'Photos - scarecrows', 3, 50, 'Scarecrow photos', 'Scarecrows', 'frmScarecrow', 'photos');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (16, 'Fell race - senior', 4, 10, 'Senior fell race', 'Senior', 'frmFellRaceSenior', 'fellrace');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (17, 'Fell race - junior', 4, 20, 'Junior fell race', 'Junior', 'frmFellRaceJunior', 'fellrace');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (18, 'Fell race - results', 4, 30, 'Search fell race results', 'Results', 'frmFellRaceResults', 'fellrace');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (19, 'Fell race - photos', 4, 40, 'Fell race photos', 'Photos', 'frmFellRacePhotos', 'fellrace');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (20, 'Scarecrows - 2010 competitio', 5, 10, 'The 2010 scarecrow competitio', '2010 competiitio', 'frmScarecrowCompetitio', 'scarecrow');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (21, 'Scarecrows - photos', 5, 20, 'Scarecrow photos', 'Photos', 'frmScarecrowPhotos', 'scarecrow');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (22, 'Scarecrows- previous years', 5, 30, 'Previous year winners and scarecrow competitions', 'Previous years', 'frmScarecrowPrevious', 'scarecrow');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (23, 'Help us - committee', 6, 10, 'Meet the organisers', 'Who organises it', 'frmHelpCommittee', 'help');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (24, 'Help us - meetings', 6, 20, 'When we meet', 'When and where we meet', 'frmHelpMeetings', 'help');
INSERT [dba].[tbm] ([MID], [MName], [PMID], [SOrder], [Ttip], [VText], [WPage], [FName]) VALUES (25, 'Help us - finances', 6, 30, 'Cl finances', 'Finances', 'frmHelpFinaces', 'help');
WITH menus AS ( 
	SELECT 
		MID,
		MName,
		CAST('Top' AS varchar(100)) AS Breadcrumb
	FROM 
		tbm
	WHERE 
		PMID  IS NULL 
        UNION ALL 
	SELECT 
		submenus.MID,
		submenus.MName,
		CAST((m.Breadcrumb + ' > ' + m.MName)
			AS varchar(100)) AS Breadcrumb
	FROM 
		tbm AS submenus
		INNER JOIN menus AS m
			ON submenus.PMID=m.MID
	) SELECT * FROM menus order by 1;
drop if exists [dba].[tbm];
