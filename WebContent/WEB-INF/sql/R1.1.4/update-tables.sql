drop procedure if exists pUpdateData_Temp;

DELIMITER $$
create procedure pUpdateData_Temp()
begin
	declare cnt integer;
	declare vId bigint(20);
	declare vKey VARCHAR(20);
	
	set vKey = 'AREA_FILTER';
	select count(cId) into cnt from tParameter where cKey=vKey;
	if (cnt > 1) then
		select cId INTO vId from tParameter where ckey=vKey limit 1;
		delete from tParameter where cid = vId;
	end if; 

	SET vKey = 'JASPER_FOLDER';
	select count(cId) into cnt from tParameter where cKey=vKey;
	if (cnt > 1) then
		select cId INTO vId from tParameter where ckey=vKey limit 1;
		delete from tParameter where cid = vId;
	end if; 

	SET vKey = 'RANGE_MARK';
	select count(cId) into cnt from tParameter where cKey=vKey;
	if (cnt > 1) then
		select cId INTO vId from tParameter where ckey=vKey limit 1;
		delete from tParameter where cid = vId;
	end if; 
	
	SET vKey = 'BOOTSTRAP';
	select count(cId) into cnt from tParameter where cKey=vKey;
	if (cnt > 1) then
		select cId INTO vId from tParameter where ckey=vKey limit 1;
		delete from tParameter where cid = vId;
	end if; 
	
end$$
DELIMITER ;

call pUpdateData_Temp;
drop procedure if exists pUpdateData_Temp;

ALTER TABLE tParameter CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;