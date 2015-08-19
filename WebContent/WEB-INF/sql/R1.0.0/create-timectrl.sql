CREATE TABLE tFile (
	cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cFileName		VARCHAR(255) NOT NULL COMMENT 'Nombre del archivo, es el identificador',
    cDateTime		DATE NOT NULL COMMENT 'Fecha de creacion',
    cSize			BIGINT NULL COMMENT 'Tamano del archivo'
) ENGINE=innoDB;

CREATE TABLE tFileContent (
	cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cFile			BIGINT NOT NULL COMMENT 'relacion con la tabla tFile',
	cLine			TEXT COMMENT 'Es una fila del archivo',
	cOrder			INT NOT NULL COMMENT 'Orden de la fila dentro del archivo' 
) ENGINE=innoDB;

CREATE TABLE tTimeCtrl(
	cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cFile			BIGINT NOT NULL,
	cEmployeeKey	VARCHAR(15) NOT NULL,
	cDate			DATE NOT NULL,
	cTurn			VARCHAR(5),
	cOnDuty			TIME DEFAULT NULL,
	cOffDuty		TIME DEFAULT NULL,
	cClockIn		TIME DEFAULT NULL,
	cClockOut		TIME DEFAULT NULL,
	cLate			TIME DEFAULT NULL,
	cEarly			TIME DEFAULT NULL,
	cWorkTime		TIME DEFAULT NULL,
	cWeekEnd		BIT,
	cHoliday		BIT
) ENGINE=innoDB;

CREATE TABLE tParameter (
  cId			BIGINT PRIMARY KEY UNIQUE AUTO_INCREMENT,
  cKey 			VARCHAR(20) NOT NULL,
  cLabel		VARCHAR(100) NOT NULL,
  cValue		VARCHAR(300) NOT NULL,
  cDataType		BIGINT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tDataType (
	cId		BIGINT UNIQUE AUTO_INCREMENT,
	cKey	VARCHAR(10) NOT NULL, 
	cName	VARCHAR(20) NOT NULL,
	PRIMARY KEY(cId)
) ENGINE=InnoDB;

CREATE TABLE tRol (
	cId			BIGINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cName		VARCHAR(50) NULL ,
	cDeleted	BIT NOT NULL DEFAULT 0
) ENGINE=innoDB;

CREATE TABLE tR_UserRol (
	cUser 		BIGINT NOT NULL,
	cRol		BIGINT NOT NULL,
	PRIMARY KEY(cUser,cRol)
) ENGINE=innoDB;

CREATE TABLE tOption (
	cId			BIGINT  NOT NULL AUTO_INCREMENT,
	cKey		VARCHAR(20) NOT NULL UNIQUE,
	cLabel 		VARCHAR(50) NOT NULL,
	cUrl		VARCHAR(100) NULL,
	cParent		BIGINT NULL,
	cType		BIGINT NOT NULL DEFAULT '1',
	cOrder		INTEGER NOT NULL DEFAULT '0',
	PRIMARY KEY(cId)
) ENGINE=innoDB;

CREATE TABLE tR_RolOption (
	cRol		BIGINT NOT NULL,
	cOption		BIGINT NOT NULL,
	PRIMARY KEY(cRol, cOption)
) ENGINE=innoDB;

/* Crea tabla Empleados */
create table tEmployee (
	cId					BIGINT(20)  NOT NULL auto_increment,
	cKey				VARCHAR(25) NOT NULL COMMENT 'Identificador',
	cRut				VARCHAR(11) 	NULL COMMENT 'Rut',
	cName				VARCHAR(50) NOT NULL COMMENT 'Nombre',
	cPost				BIGINT(20) NULL COMMENT 'Codigo Cargo',
	cArea				BIGINT(20) NULL COMMENT 'Codigo Area',
	cPrivilege			BIGINT(20) NULL DEFAULT 1,
	cEnabled			BIT NOT NULL DEFAULT 1,
	cFingerprint		TEXT NULL,
	cFlag				INTEGER NULL,
	cFingerIndex		INTEGER NULL,
	cUsername			VARCHAR(40) NULL,
	/*
	cBirthDate			DATE COMMENT 'Fecha de nacimiento',
	cAddress			VARCHAR(100) COMMENT 'Direccion particular',
	cGenere				BIGINT(20) NULL COMMENT 'Genero Femenino o Masculino',
	cComuna				BIGINT(20) NULL,
	cCountry			BIGINT(20) NULL COMMENT 'Nacionalidad',
	cPhone				VARCHAR(10),
	cMobile				VARCHAR(10),
	cMaritalStatus		BIGINT(20) NULL COMMENT 'Estado Civil',
	cMovil				VARCHAR(10),
	cEmail				VARCHAR(50),
	*/
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tPrivilege(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				INTEGER NOT NULL,
	cName				VARCHAR(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tPost(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				VARCHAR(10) NOT NULL DEFAULT '',
	cName				VARCHAR(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tArea(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				VARCHAR(10) NOT NULL DEFAULT '',
	cName				VARCHAR(50) NOT NULL,
	cCostCenter			VARCHAR(5) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tTurn(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cName				VARCHAR(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tTurnDay(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cTurn				BIGINT(20) NOT NULL,
	cDay				INT NOT NULL,
	cBusinessDay		BOOLEAN NOT NULL DEFAULT 1,
	cStartTime			VARCHAR(5) NOT NULL,
	cEndTime			VARCHAR(5) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tR_EmployeeTurn (
	cId 				BIGINT(20) NOT NULL auto_increment,
	cEmployee			BIGINT(20) NOT NULL,
	cTurn				BIGINT(20) NOT NULL,
	cStartDate			DATE,
	cEndDate			DATE,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tFiscalDate(
	cId			BIGINT(20) NOT NULL auto_increment,
	cDate		DATE NOT NULL UNIQUE,
	cReason		VARCHAR(50) DEFAULT '',
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tMachine(
	cId			BIGINT(20) NOT NULL auto_increment,
	cName		VARCHAR(50) NOT NULL DEFAULT '',
	cIP			VARCHAR(15) NOT NULL,
	cPort		INTEGER NOT NULL,
	cLastAccess	TIMESTAMP NULL,
	cSerial		VARCHAR(20) NULL COMMENT 'Numero de Serie',
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tAttendanceLog(
	cId				BIGINT(20) NOT NULL auto_increment,
	cEmployeeKey	VARCHAR(15) NULL,
	cMachine		BIGINT(20) NOT NULL,
	cDate			TIMESTAMP,
	cMarkType		BIGINT(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tMarkType(
	cId				BIGINT(20) NOT NULL auto_increment,
	cKey			VARCHAR(1) NOT NULL,
	cName			VARCHAR(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

/************  R E P O R T E S   P A R A M E T R I Z A B L E S ****************/
create table tReportOutParam(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cType				BIGINT(20) NOT NULL,
	cKey				VARCHAR(20) NOT NULL DEFAULT '',
	cName				VARCHAR(255) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tReportOutType(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				VARCHAR(20) NOT NULL DEFAULT '',
	cName				VARCHAR(50) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tReport(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cName				VARCHAR(50) NOT NULL,
	cJasperFile			VARCHAR(30) NOT NULL,
	cOutType			BIGINT(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tReportOutValue(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cParam				BIGINT(20) NOT NULL,
	cType				BIGINT(20) NOT NULL,
	cReport				BIGINT(20) NOT NULL,
	cValue				VARCHAR(255) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tReportParamType(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				VARCHAR(20) NOT NULL DEFAULT '',
	cName				VARCHAR(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tReportParam(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cReport				BIGINT(20) NOT NULL,
	cName				VARCHAR(20) NOT NULL,
	cType				BIGINT(20) NOT NULL,
	cValue				VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY (cId)
) ENGINE=InnoDB;
/************  R E P O R T E S   P A R A M E T R I Z A B L E S ****************/

create table tLicense(
       cId              BIGINT(20) NOT NULL auto_increment,
       cEmployee        BIGINT(20) NOT NULL COMMENT 'Identificador del empleado quien tiene las horas extras',
       cStartDate       DATE NOT NULL COMMENT 'Día del período de comienzo de licencia',
       cEndDate         DATE NOT NULL COMMENT 'Día del período de término de licencia',
       cLicenseCause    BIGINT(20) NOT NULL COMMENT 'Razon de la aucencia',
	   cDocument		VARCHAR(15) NULL COMMENT 'Numero de documento',
       PRIMARY KEY (cId)
) ENGINE=InnoDB;

CREATE TABLE tLicenseCause (
	cId					BIGINT(20) UNIQUE AUTO_INCREMENT,
	cName				VARCHAR(30) NOT NULL COMMENT 'Descripción de la causa',
	PRIMARY KEY(cId)
) ENGINE=InnoDB;


/*
create table tGenere(
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				CHAR(1) NOT NULL DEFAULT ' ',
	cName				VARCHAR(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

CREATE TABLE tMaritalStatus (
	cId BIGINT UNIQUE AUTO_INCREMENT,
	cKey	VARCHAR(10) NOT NULL,
	cName	VARCHAR(15) NOT NULL,
	PRIMARY KEY(cId)
) ENGINE=InnoDB;

CREATE TABLE tCountry (
 	cId			BIGINT UNIQUE AUTO_INCREMENT,
 	cKey		CHAR(3) NOT NULL DEFAULT '' UNIQUE,
 	cName		VARCHAR(60) NOT NULL DEFAULT '',
	PRIMARY KEY(cId)
) ENGINE=InnoDB;

CREATE TABLE tComuna (
	cId			BIGINT UNIQUE AUTO_INCREMENT,
	cName		VARCHAR(50) NOT NULL,
	cRegion		INTEGER NOT NULL,
	cPriority	INTEGER NOT NULL DEFAULT '0',
	PRIMARY KEY(cId)  
) ENGINE=InnoDB;

*/

DROP TABLE IF EXISTS `checkinout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checkinout` (
  `USERID` int(11) NOT NULL,
  `CHECKTIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CHECKTYPE` varchar(1) DEFAULT NULL,
  `VERIFYCODE` int(11) DEFAULT '0',
  `SENSORID` varchar(5) DEFAULT NULL,
  `Memoinfo` varchar(30) DEFAULT NULL,
  `WorkCode` int(11) DEFAULT '0',
  `sn` varchar(20) DEFAULT NULL,
  `UserExtFmt` int(11) DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `userinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userinfo` (
  `USERID` int(11) NOT NULL AUTO_INCREMENT,
  `Badgenumber` varchar(24) NOT NULL,
  `SSN` varchar(20) DEFAULT NULL,
  `Name` varchar(40) DEFAULT NULL,
  `Gender` varchar(8) DEFAULT NULL,
  `TITLE` varchar(20) DEFAULT NULL,
  `PAGER` varchar(20) DEFAULT NULL,
  `BIRTHDAY` datetime DEFAULT NULL,
  `HIREDDAY` datetime DEFAULT NULL,
  `street` varchar(80) DEFAULT NULL,
  `CITY` varchar(2) DEFAULT NULL,
  `STATE` varchar(2) DEFAULT NULL,
  `ZIP` varchar(12) DEFAULT NULL,
  `OPHONE` varchar(20) DEFAULT NULL,
  `FPHONE` varchar(20) DEFAULT NULL,
  `VERIFICATIONMETHOD` int(11) DEFAULT NULL,
  `DEFAULTDEPTID` int(11) DEFAULT '1',
  `SECURITYFLAGS` int(11) DEFAULT NULL,
  `ATT` int(11) NOT NULL DEFAULT '1',
  `INLATE` int(11) NOT NULL DEFAULT '1',
  `OUTEARLY` int(11) NOT NULL DEFAULT '1',
  `OVERTIME` int(11) NOT NULL DEFAULT '1',
  `SEP` int(11) NOT NULL DEFAULT '1',
  `HOLIDAY` int(11) NOT NULL DEFAULT '1',
  `MINZU` varchar(8) DEFAULT NULL,
  `PASSWORD` varchar(50) DEFAULT NULL,
  `LUNCHDURATION` int(11) NOT NULL DEFAULT '1',
  `PHOTO` longblob,
  `mverifypass` varchar(10) DEFAULT NULL,
  `Notes` longblob,
  `privilege` int(11) DEFAULT '0',
  `InheritDeptSch` int(11) DEFAULT '1',
  `InheritDeptSchClass` int(11) DEFAULT '1',
  `AutoSchPlan` int(11) DEFAULT '1',
  `MinAutoSchInterval` int(11) DEFAULT '24',
  `RegisterOT` int(11) DEFAULT '1',
  `InheritDeptRule` int(11) DEFAULT '1',
  `EMPRIVILEGE` int(11) DEFAULT '0',
  `CardNo` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`USERID`),
  UNIQUE KEY `Badgenumber` (`Badgenumber`)
) ENGINE=MyISAM AUTO_INCREMENT=463 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


DELIMITER $$
/**
DROP FUNCTION IF EXISTS fLastPosition;
CREATE FUNCTION fLastPosition(vSearch VARCHAR(100), vString VARCHAR(100)) RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT -1;
	
	SELECT LENGTH(vString) - LOCATE(REVERSE(vSearch), REVERSE(vString))+1 INTO vOut;

	RETURN vOut;
END$$ 
*/
/*
CREATE TRIGGER AfterInsertOnCheckinout AFTER INSERT ON checkinout
  FOR EACH ROW BEGIN
	DECLARE vMarkId BIGINT(20);
	DECLARE vUserId BIGINT(20);
	
	SELECT Badgenumber INTO vUserId FROM userinfo WHERE USERID = NEW.USERID;
	SELECT cId INTO vMarkId FROM tMarkType WHERE cKey = NEW.CheckType;
	  
	INSERT INTO tAttendanceLog(cEmployeeKey, cMachine, cDate, cMarkType) 
		VALUES (vUserId, 1, NEW.CheckTime, vMarkId);

  END$$

  
  
CREATE TRIGGER AfterInsertOnUserinfo AFTER INSERT ON userinfo
  FOR EACH ROW BEGIN	
  	DECLARE vArea BIGINT(20);

	INSERT INTO tEmployee(cKey, cRut, cName, cPost, cArea, cUsername) 
		VALUES (NEW.Badgenumber, NEW.SSN, NEW.Name, 1, 1, REPLACE(NEW.Name, ' ', '.'));
	
	SET vArea = NEW.DEFAULTDEPTID;
	
	IF(NOT EXISTS(SELECT cId FROM tArea WHERE cKey = vArea)) THEN
		INSERT INTO tArea(cKey, cName, cCostCenter) VALUES(vArea, CONCAT('Area ', vArea), CONCAT('CC', vArea));
	END IF;
	
  END$$
*/
DELIMITER ;
