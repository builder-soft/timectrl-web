@echo off

IF "%BS_PATH%" == "" GOTO error

SET ALL_JARS=-classpath ".;%BS_PATH%\lib\mysql-connector-java-5.1.26-bin.jar;%BS_PATH%\lib\BSframework-lib-1.3.jar;%BS_PATH%\lib\timectrl-common.jar;%BS_PATH%\lib\dom4j-1.6.1.jar;%BS_PATH%\lib\timectrl-bl.jar;%BS_PATH%\lib\jaxen-1.1-beta-6.jar;"

java %ALL_JARS% cl.buildersoft.timectrl.console.BuildLicense %*

goto end

:error
	echo No esta definida la variable de entorno BS_PATH
	
:end
SET ALL_JARS=