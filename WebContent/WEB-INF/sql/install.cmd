@echo off
IF "%1" == "" GOTO err_handler
	cls
	call msg.cmd Version R1.0.0 
	cd R1.0.0
	call run-all.cmd %1
	call ..\msg.cmd Version R1.0.1 
	cd ..\R1.0.1
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.2 
	cd ..\R1.0.2
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.3 
	cd ..\R1.0.3
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.4 
	cd ..\R1.0.4
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.5 
	cd ..\R1.0.5
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.6 
	cd ..\R1.0.6
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.7 
	cd ..\R1.0.7
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.8 
	cd ..\R1.0.8
	call run-once.cmd %1
	call ..\msg.cmd Version R1.0.9 
	cd ..\R1.0.9
	call run-once.cmd %1
	call ..\msg.cmd Version R1.1.0 
	cd ..\R1.1.0
	call run-once.cmd %1
	call ..\msg.cmd Version R1.1.1 
	cd ..\R1.1.1
	call run-once.cmd %1
	call ..\msg.cmd Version R1.1.2 
	cd ..\R1.1.2
	call run-once.cmd %1
	call ..\msg.cmd Version R1.1.3 
	cd ..\R1.1.3
	call run-once.cmd %1
	call ..\msg.cmd Version R1.1.4 
	cd ..\R1.1.4
	call run-once.cmd %1
	call ..\msg.cmd Version R1.2.0 
	cd ..\R1.2.0
	call run-once.cmd %1
	call ..\msg.cmd Version R1.2.1 
	cd ..\R1.2.1
	call run-once.cmd %1
	
	call ..\msg.cmd Version R1.2.2 
	cd ..\R1.2.2
	call run-once.cmd %1
	
	cd ..\R1.2.3
	call run-once.cmd %1
	
	cd ..\R1.2.4
	call run-once.cmd %1
	
	cd ..\R1.2.5
	call run-once.cmd %1
	cd ..\R1.2.6
	call run-once.cmd %1
	cd ..\R1.2.8
	call run-once.cmd %1
	cd ..\R1.2.9
	call run-once.cmd %1
	cd ..\R1.2.10
	call run-once.cmd %1
	cd ..\R1.2.12
	call run-once.cmd %1
	cd ..\R1.2.13
	call run-once.cmd %1
	cd ..\R1.2.14
	call run-once.cmd %1
	cd ..\R1.2.15
	call run-once.cmd %1

	cd ..
	goto end_handler
:err_handler
	echo No se indico nombre de la base de datos, ejecute: 
	echo $ run-all timectrl
	
:end_handler
	echo Done!