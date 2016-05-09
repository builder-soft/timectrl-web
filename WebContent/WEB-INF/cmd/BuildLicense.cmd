@echo off

IF "%BS_PATH%" == "" GOTO error

rem SET ALL_JARS=-classpath ".;%BS_PATH%\lib\mysql-connector-java-5.1.26-bin.jar;%BS_PATH%\lib\BSframework-lib-1.3.jar;%BS_PATH%\lib\timectrl-common.jar;%BS_PATH%\lib\dom4j-1.6.1.jar;%BS_PATH%\lib\timectrl-bl.jar;%BS_PATH%\lib\jaxen-1.1-beta-6.jar;"
SET ALL_JARS=-classpath "%CATALINA_HOME%\lib\shared\commons-logging-1.1.3.jar;%CATALINA_HOME%\lib\shared\mysql-connector-java-5.1.26-bin.jar;%CATALINA_HOME%\lib\shared\jasperreports-5.6.0.jar;%CATALINA_HOME%\lib\shared\jasperreports-applet-5.6.0.jar;%CATALINA_HOME%\lib\shared\jasperreports-fonts-5.6.0.jar;%CATALINA_HOME%\lib\shared\jasperreports-javaflow-5.6.0.jar;%CATALINA_HOME%\lib\shared\commons-collections-3.2.1.jar;%CATALINA_HOME%\lib\shared\commons-digester-2.1.jar;%CATALINA_HOME%\lib\shared\groovy-all-2.0.1.jar;%CATALINA_HOME%\lib\shared\iText-2.1.7.js2.jar;%CATALINA_HOME%\lib\shared\BSframework-lib-1.3.jar;%CATALINA_HOME%\lib\shared\commons-fileupload-1.2.2.jar;%CATALINA_HOME%\lib\servlet-api.jar;%CATALINA_HOME%\lib\shared\poi-3.11-20141221.jar;%CATALINA_HOME%\lib\shared\timectrl-common.jar;%CATALINA_HOME%\lib\shared\catalina.jar;%CATALINA_HOME%\lib\shared\poi-ooxml-3.11-20141221.jar;%CATALINA_HOME%\lib\shared\xmlbeans-2.6.0.jar;%CATALINA_HOME%\lib\shared\poi-ooxml-schemas-3.11-20141221.jar;%CATALINA_HOME%\lib\shared\javax.mail.jar;%CATALINA_HOME%\lib\shared\dom4j-1.6.1.jar;%CATALINA_HOME%\lib\shared\jaxen-1.1-beta-6.jar;%CATALINA_HOME%\lib\shared\com4j.jar"

java %ALL_JARS% cl.buildersoft.timectrl.console.BuildLicense %*

goto end

:error
	echo No esta definida la variable de entorno BS_PATH
	
:end
SET ALL_JARS=