--Setting Up IoT Data Pipeline in Snowflake
/*setup of a data pipeline in Snowflake for IoT (Internet of Things) data ingestion, processing, and querying. The steps include:
Database and schema creation.
Table creation to store IoT data.
Integration with AWS S3 for data ingestion.
Automating data loading with Snowpipe.
Querying data for verification. */

--IOT_V2_TABLE CREATION
/*Create a dedicated database and schema for organizing IoT data.*/

CREATE OR REPLACE DATABASE IOT_DB;
CREATE OR REPLACE SCHEMA IOT_SCHEMA;

/*File Format Configuration---Define a CSV file format for loading data from AWS S3.*/

create or replace file format iot_csv
type='csv'
compression='none'
field_delimiter=','
field_optionally_enclosed_by='\042' -- double quotes ASCII value
skip_header=1;

/* Table Creation ---- Create tables to store IoT data. Each table corresponds to a specific IoT data stream.*/

create or replace TABLE IOT_DB.IOT_SCHEMA.LOAD_IOTV2_EUEXPERIENCE00320055 
(
	ATOMICCONSENTS VARCHAR(16777216),
	DATA VARIANT,
	ORIGINREGION VARCHAR(16777216),
	REQUESTID VARCHAR(16777216),
	SERIALNUMBER VARCHAR(16777216),
	SOURCE_FILE_NAME VARCHAR(16777216),
	EVENT_LOCAL_TIMESTAMP VARCHAR(16777216)
);

create or replace TABLE LOAD_IOTV2_EUEXPERIENCE00320055_COPY as select * from LOAD_IOTV2_EUEXPERIENCE00320055;

create or replace TABLE IOT_DB.IOT_SCHEMA.LOAD_IOTV2_JPEXPERIENCE00320055 (
	ATOMICCONSENTS VARCHAR(16777216),
	DATA VARIANT,
	ORIGINREGION VARCHAR(16777216),
	REQUESTID VARCHAR(16777216),
	SERIALNUMBER VARCHAR(16777216),
	SOURCE_FILE_NAME VARCHAR(16777216),
	EVENT_LOCAL_TIMESTAMP VARCHAR(16777216)
);

create or replace TABLE LOAD_IOTV2_JPEXPERIENCE00320055_COPY as select * from LOAD_IOTV2_JPEXPERIENCE00320055;
select * from IOT_DB.IOT_SCHEMA.LOAD_IOTV2_EUEXPERIENCE00320055_COPY;

--endMCUtemperature
--startMCUtemperature

create or replace TABLE IOT_DB.IOT_SCHEMA.LOAD_IOTV2_NZEXPERIENCE002F0052 (
	ATOMICCONSENTS VARCHAR(16777216),
	DATA VARIANT,
	ORIGINREGION VARCHAR(16777216),
	REQUESTID VARCHAR(16777216),
	SERIALNUMBER VARCHAR(16777216),
	SOURCE_FILE_NAME VARCHAR(16777216),
	EVENT_LOCAL_TIMESTAMP VARCHAR(16777216)
);

create or replace TABLE LOAD_IOTV2_NZEXPERIENCE002F0052_COPY as select * from LOAD_IOTV2_NZEXPERIENCE002F0052;

----------------------------------------------------AWS (S3) INTEGRATION------------------------------------------------------------------------
/* AWS S3 Integration--- Enable Snowflake to access files stored in an AWS S3 bucket.*/

CREATE OR REPLACE STORAGE integration iot_si
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN ='arn:aws:iam::414409927123:role/iotv2_role' 
STORAGE_ALLOWED_LOCATIONS =('s3://bp-iotv2/');

DESC integration iot_si;

--Create a Stage:

CREATE OR REPLACE STAGE iot_stage
URL ='s3://bp-iotv2'
file_format = iot_csv
storage_integration = iot_si;

SHOW STAGES;

--List Files in the Stage:

LIST @iot_stage;

-------------------------------------------------iotv2_snowpipe--------------------------------------------------------------------
-- Automating Data Loading with Snowpipe ----- Automate loading data into Snowflake from specific S3 subfolders.

CREATE OR REPLACE PIPE iotv2_snowpipe_EUEXPERIENCE00320055 AUTO_INGEST = TRUE AS
COPY INTO IOT_DB.IOT_SCHEMA.LOAD_IOTV2_EUEXPERIENCE00320055 --yourdatabase -- your schema ---your table
FROM '@iot_stage/iotv2_prd_euexperience00320055/' --s3 bucket subfolde4r name
FILE_FORMAT = iot_csv; --YOUR CSV FILE FORMAT NAME

CREATE OR REPLACE PIPE iotv2_snowpipe_JPEXPERIENCE00320055 AUTO_INGEST = TRUE AS
COPY INTO IOT_DB.IOT_SCHEMA.LOAD_IOTV2_JPEXPERIENCE00320055
FROM '@iot_stage/iotv2_prd_jpexperience00320055/' 
FILE_FORMAT = iot_csv;

CREATE OR REPLACE PIPE iotv2_snowpipe_NZEXPERIENCE002F0052 AUTO_INGEST = TRUE AS
COPY INTO IOT_DB.IOT_SCHEMA.LOAD_IOTV2_NZEXPERIENCE002F0052
FROM '@iot_stage/iotv2_prd_nzexperience002f0052/' 
FILE_FORMAT = iot_csv;


----------------------------------------------------------PIPEREFRESH-----------------------------------------------------------------

--Refreshing Snowpipes ---- Trigger Snowpipe manually to load data.

ALTER PIPE iotv2_snowpipe_EUEXPERIENCE00320055 refresh;
ALTER PIPE  iotv2_snowpipe_JPEXPERIENCE00320055 refresh;
ALTER PIPE  iotv2_snowpipe_NZEXPERIENCE002F0052 refresh;

---Querying Data----- Verify data ingestion by running queries on the tables.

SELECT COUNT(*) FROM LOAD_IOTV2_EUEXPERIENCE00320055;
SELECT COUNT(*) FROM LOAD_IOTV2_JPEXPERIENCE00320055;
SELECT COUNT(*) FROM LOAD_IOTV2_NZEXPERIENCE002F0052;

--Fetch Sample Data:
SELECT * FROM LOAD_IOTV2_EUEXPERIENCE00320055;
SELECT * FROM LOAD_IOTV2_JPEXPERIENCE00320055;
SELECT * FROM LOAD_IOTV2_NZEXPERIENCE002F0052;
