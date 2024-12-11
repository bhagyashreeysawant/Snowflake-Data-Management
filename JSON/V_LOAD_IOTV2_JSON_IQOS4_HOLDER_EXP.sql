/*Overview

This document explains the creation of a Snowflake view IOT_DB.IOT_SCHEMA.V_LOAD_IOTV2_JSON_IQOS4_HOLDER_EXP, which transforms JSON data into a structured format for querying and analysis. The view uses Snowflake's PARSE_JSON function to extract specific JSON attributes and makes them accessible as columns in the view.*/

/*Key SQL Components

a. Creating the View

The CREATE OR REPLACE VIEW statement creates a view by combining data from multiple tables and parsing JSON data into structured columns. The view structure is defined by the following columns:

ATOMICCONSENTS: Extracted as-is.

PARSE_JSON(DATA): The DATA field is parsed using the PARSE_JSON function to retrieve attributes like recordIndex, recordFormatVersion, expCredit, etc.

b. UNION of Multiple Tables

The view combines data from three source tables (LOAD_IOTV2_EUEXPERIENCE00320055, LOAD_IOTV2_JPEXPERIENCE00320055, LOAD_IOTV2_NZEXPERIENCE002F0052) using the UNION operator.

c. JSON Parsing Using PARSE_JSON

The PARSE_JSON function parses the DATA field (a JSON string) into a structured JSON object, from which individual attributes are accessed using : (colon) notation.*/

create or replace view IOT_DB.IOT_SCHEMA.V_LOAD_IOTV2_JSON_IQOS4_HOLDER_EXP
(
	ATOMICCONSENTS,
	RECORDINDEX,
	RECORDFORMATVERSION,
	RECORDSIZE,
	STARTTIME,
	EXPCREDIT,
	STARTBATTERYGAUGELEVEL,
	ENDBATTERYGAUGELEVEL,
	CONTROLSTARTBATTERYVOLTAGE,
	CONTROLSTARTTEMPERATURE2,
	CONTROLINTERNALRESISTORINDICATOR,
	CONTROLENDBATTERYVOLTAGE,
	CONTROLENDTEMPERATURE2,
	CONTROLSTOPREASON,
	STARTREASON,
	SKU,
	STARTTEMP1,
	STARTTEMP2,
    START_MCU_TEMPERATURE,
    END_MCU_TEMPERATURE,
	STARTDCDCVOLTAGE,
	ENDTEMP1,
	ENDTEMP2,
	ENDDCDCVOLTAGE,
	DCDCVOLTAGEVARIATION,
	INTERNALRESISTORINDICATOR,
	STARTCONDUCTANCE,
	FIRSTVALLEYCONDUCTANCE,
	FIRSTDELTASCURVECONDUCTANCE,
	LASTDELTASCURVECONDUCTANCE,
	PREHEATSLOPETIME,
	OUTOFRANGEREGULATION,
	DRIFTCOMPENSATIONERROR,
	HEATINGDURATION,
	PAUSEDURATION,
	PAUSETIMESTAMP,
	PAUSEENERGY,
	HEATINGENERGY,
	ENGINESTOPREASON,
	HEATINGPROFILE,
	STARTBATTERYVOLTAGE,
	ENDBATTERYVOLTAGE,
	BATTERYVOLTAGEVARIATION,
	LASTVALLEYCONDUCTANCE,
	FIRSTHILLCONDUCTANCE,
	CALIBRATIONDURATION,
	HOTALARMTREATED,
	MAXIMUMDELTASVARIATION,
	VALIDSCURVEDETECTED,
	COOLINGSEQUENCEFAILURE,
	CALIBRATIONPULSEFAILURE,
	APPLICATIONVERSION,
	PUFFCOUNT,
	PUFFS,
	INDEX,
	PUFFCOUNTBEFOREPAUSE,
	PUFFCOUNTAFTERPAUSE,
	PUFFVOLUMEAFTER14PUFFS,
	TOTALPUFFVOLUME,
    PUFFDURATION,
	PAUSEPROFILE,
	ENERGYTOFIRSTVALLEY,
	STICKEXTRACTIONDURATION,
	ENGINEFLAGS,
	CONTROLFLAGS,
	ORIGINREGION,
	REQUESTID,
	SERIALNUMBER,
	SOURCE_FILE_NAME,
	EVENT_LOCAL_TIMESTAMP
) as
SELECT 
EXP3.ATOMICCONSENTS,
parse_json(DATA):recordIndex,
parse_json(DATA):recordFormatVersion,
parse_json(DATA):recordSize,
parse_json(DATA):startTime,
parse_json(DATA):expCredit,
parse_json(DATA):startBatteryGaugeLevel,
parse_json(DATA):endBatteryGaugeLevel,
parse_json(DATA):controlStartBatteryVoltage,
parse_json(DATA):controlStartTemperature2,
parse_json(DATA):controlInternalResistorIndicator,
parse_json(DATA):controlEndBatteryVoltage,
parse_json(DATA):controlEndTemperature2,
parse_json(DATA):controlStopReason,
parse_json(DATA):startReason,
parse_json(DATA):SKU,
parse_json(DATA):startTemp1,
parse_json(DATA):startTemp2,
parse_json(DATA):startMCUtemperature,
parse_json(DATA):endMCUtemperature,
parse_json(DATA):startDCDCVoltage,
parse_json(DATA):endTemp1,
parse_json(DATA):endTemp2,
parse_json(DATA):endDCDCVoltage,
parse_json(DATA):DCDCVoltageVariation,
parse_json(DATA):internalResistorIndicator,
parse_json(DATA):startConductance,
parse_json(DATA):firstValleyConductance,
parse_json(DATA):firstDeltaScurveConductance,
parse_json(DATA):lastDeltaScurveConductance,
parse_json(DATA):preheatSlopeTime,
parse_json(DATA):outOfRangeRegulation,
parse_json(DATA):driftCompensationError,
parse_json(DATA):heatingDuration,
parse_json(DATA):pauseDuration,
parse_json(DATA):pauseTimeStamp,
parse_json(DATA):pauseEnergy,
parse_json(DATA):heatingEnergy,
parse_json(DATA):engineStopReason,
parse_json(DATA):heatingProfile,
parse_json(DATA):startBatteryVoltage,
parse_json(DATA):endBatteryVoltage,
parse_json(DATA):batteryVoltageVariation,
parse_json(DATA):lastValleyConductance,
parse_json(DATA):firstHillConductance,
parse_json(DATA):calibrationDuration,
parse_json(DATA):hotAlarmTreated,
parse_json(DATA):maximumDeltaSvariation,
parse_json(DATA):validScurveDetected,
parse_json(DATA):coolingSequenceFailure,
parse_json(DATA):calibrationPulseFailure,
parse_json(DATA):application version,
parse_json(DATA):puffCount,
parse_json(DATA):puffs,
parse_json(DATA):index,
NULL,
NULL,
NULL,
NULL,
parse_json(DATA):puffDuration,
NULL,
NULL,
NULL,
NULL,
NULL,
EXP3.ORIGINREGION,
REPLACE(EXP3.REQUESTID,'__USAGE_DATA',''),
EXP3.SERIALNUMBER,
EXP3.SOURCE_FILE_NAME,
EXP3.EVENT_LOCAL_TIMESTAMP
FROM (SELECT ATOMICCONSENTS,DATA,ORIGINREGION,REQUESTID,SERIALNUMBER,SOURCE_FILE_NAME,EVENT_LOCAL_TIMESTAMP
FROM IOT_DB.IOT_SCHEMA.LOAD_IOTV2_EUEXPERIENCE00320055
UNION
SELECT ATOMICCONSENTS,DATA,ORIGINREGION,REQUESTID,SERIALNUMBER,SOURCE_FILE_NAME,EVENT_LOCAL_TIMESTAMP
FROM IOT_DB.IOT_SCHEMA.LOAD_IOTV2_JPEXPERIENCE00320055
UNION
SELECT ATOMICCONSENTS,DATA,ORIGINREGION,REQUESTID,SERIALNUMBER,SOURCE_FILE_NAME,EVENT_LOCAL_TIMESTAMP
FROM IOT_DB.IOT_SCHEMA.LOAD_IOTV2_NZEXPERIENCE002F0052
) EXP3;

SELECT * FROM IOT_DB.IOT_SCHEMA.V_LOAD_IOTV2_JSON_IQOS4_HOLDER_EXP;

SELECT * FROM IOT_DB.IOT_SCHEMA.V_LOAD_IOTV2_JSON_IQOS4_HOLDER_EXP
WHERE START_MCU_TEMPERATURE IS NOT NULL AND END_MCU_TEMPERATURE IS NOT NULL;

/*Filtering Non-NULL MCU Temperatures

Retrieve rows where startMCUtemperature and endMCUtemperature are non-NULL:*/

SELECT * FROM IOT_DB.IOT_SCHEMA.V_LOAD_IOTV2_JSON_IQOS4_HOLDER_EXP
WHERE START_MCU_TEMPERATURE <> 'null'
AND END_MCU_TEMPERATURE <> 'null';
--PUFFDURATION <> 'null'

/*Extracting Specific JSON Attributes

Extract startMCUtemperature and endMCUtemperature as string values:*/

SELECT  data:startMCUtemperature::VARCHAR as "Starting MCU Temperature Value",
data:endMCUtemperature::VARCHAR as "Ending MCU Temperature Value"
FROM LOAD_IOTV2_EUEXPERIENCE00320055
WHERE data:startMCUtemperature <> 'null'
AND data:startMCUtemperature <> 'null';


/*Extracting Puff Data

Retrieve the puffs attribute from JSON data:*/

SELECT 
data:puffs::VARCHAR as "Puffs"
--data:endMCUtemperature::VARCHAR as "Ending MCU Temperature Value"
FROM LOAD_IOTV2_EUEXPERIENCE00320055;

/*Handling NULL Values

Snowflake distinguishes between SQL NULL and JSON null values in VARIANT columns:

SQL NULL: Represents missing or unknown values.

JSON null: Stored as the string "null" in a VARIANT column.*/

NULL Values
Snowflake supports two types of NULL values in semi-structured data:

SQL NULL: SQL NULL means the same thing for semi-structured data types as it means for structured data types: the value is missing or unknown.

JSON null (sometimes called “VARIANT NULL”): 
In a VARIANT column, JSON null values are stored as a string containing the word “null” to distinguish them from SQL NULL values.

The following example contrasts SQL NULL and JSON null:;

select 
    parse_json(NULL) AS "SQL NULL", 
    parse_json('null') AS "JSON NULL", 
    parse_json('[ null ]') AS "JSON NULL",
    parse_json('{ "a": null }'):a AS "JSON NULL",
    parse_json('{ "a": null }'):b AS "ABSENT VALUE";

To convert a VARIANT "null" value to SQL NULL, cast it as a string. For example:;

select 
    parse_json('{ "a": null }'):a,
    to_char(parse_json('{ "a": null }'):a);