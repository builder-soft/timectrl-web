@echo off
echo.

IF "%CATALINA_HOME%" == "" GOTO error

SET ALL_JARS=-classpath "%CATALINA_HOME%\lib\shared\commons-logging-1.1.3.jar;%CATALINA_HOME%\lib\shared\mysql-connector-java-5.1.26-bin.jar;%CATALINA_HOME%\lib\shared\jasperreports-5.6.0.jar;%CATALINA_HOME%\lib\shared\jasperreports-applet-5.6.0.jar;%CATALINA_HOME%\lib\shared\jasperreports-fonts-5.6.0.jar;%CATALINA_HOME%\lib\shared\jasperreports-javaflow-5.6.0.jar;%CATALINA_HOME%\lib\shared\commons-collections-3.2.1.jar;%CATALINA_HOME%\lib\shared\commons-digester-2.1.jar;%CATALINA_HOME%\lib\shared\groovy-all-2.0.1.jar;%CATALINA_HOME%\lib\shared\iText-2.1.7.js2.jar;%CATALINA_HOME%\lib\shared\BSframework-lib-1.3.jar;%CATALINA_HOME%\lib\shared\commons-fileupload-1.2.2.jar;%CATALINA_HOME%\lib\shared\servlet-api.jar;%CATALINA_HOME%\lib\shared\poi-3.11-20141221.jar;%CATALINA_HOME%\lib\shared\timectrl-common.jar;%CATALINA_HOME%\lib\shared\catalina.jar;%CATALINA_HOME%\lib\shared\poi-ooxml-3.11-20141221.jar;%CATALINA_HOME%\lib\shared\xmlbeans-2.6.0.jar;%CATALINA_HOME%\lib\shared\poi-ooxml-schemas-3.11-20141221.jar;%CATALINA_HOME%\lib\shared\javax.mail.jar;%CATALINA_HOME%\lib\shared\dom4j-1.6.1.jar;%CATALINA_HOME%\lib\shared\jaxen-1.1-beta-6.jar"

rem @echo on
java %ALL_JARS% cl.buildersoft.timectrl.business.console.BuildReportConsole %*
rem @echo off

goto end

:error
	echo No esta definida la variable de entorno CATALINA_HOME
	
:end
SET ALL_JARS=