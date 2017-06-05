-- Unable to render VIEW DDL for object CONCEPTMAPSUPPORT.CODES_MAPPINGS with DBMS_METADATA attempting internal generator.

CREATE VIEW CONCEPTMAPSUPPORT.CODES_MAPPINGS AS
SELECT CS.CONSUMER_NAME,
       CS.CONSUMER_ID,
       COS.CODE_SYSTEM_NAME,
       COS.CODE_SYSTEM_ID,
       ICS.CODE_NAME,
       ICS.CODE_SYSTEM_VALUE AS CODE_VALUE,
       ICS.CODE_DATETIME AS CODE_EXTRACTION_TIME,
       ICM.METADATA_TYPE_VALUE_NUMERIC AS ACTIVITY_COUNT,
       V.VOCABULARY_NAME,
       PC.VOCABULARY_ID,
       C.CONCEPT_NAME,
       C.CONCEPT_ID,
       PROGRAMS.PROGRAM_NAME,
       NVL(CCS.CODE_CONCEPT_STATUS_NAME, 'Unmapped') AS MAPPING_STATUS,
       PC.USER_ID
FROM IDENTITY_CODE_SNAPSHOTS ICS -- WARNING: when a code has multiple names, this could duplicate rows
INNER JOIN CONSUMERS CS ON ICS.CODE_CONSUMER_ID=CS.CONSUMER_ID
INNER JOIN CODE_SYSTEMS COS ON COS.CODE_SYSTEM_ID = ICS.CODE_SYSTEM_ID
LEFT OUTER JOIN PROPRIETARY_CODES PC ON -- WARNING: when a code is mapped to several concepts, this could duplicate rows
 ICS.CODE_CONSUMER_ID = PC.CODE_CONSUMER_ID
AND ICS.CODE_SYSTEM_ID = PC.CODE_SYSTEM_ID
AND ICS.CODE_SYSTEM_VALUE = PC.CODE_SYSTEM_VALUE
LEFT OUTER JOIN CODE_CONCEPT_STATUSES CCS ON PC.CODE_CONCEPT_STATUS_ID = CCS.CODE_CONCEPT_STATUS_ID
LEFT OUTER JOIN VOCABULARIES V ON PC.VOCABULARY_ID=V.VOCABULARY_ID
LEFT OUTER JOIN CONCEPTS C ON V.VOCABULARY_ID=C.VOCABULARY_ID
AND PC.CONCEPT_ID=C.CONCEPT_ID
LEFT OUTER JOIN PROGRAM_CONCEPTS ON -- WARNING: when a concept exists in multiple programs, this could duplicate rows
 PC.VOCABULARY_ID=PROGRAM_CONCEPTS.VOCABULARY_ID
AND PC.CONCEPT_ID=PROGRAM_CONCEPTS.CONCEPT_ID
LEFT OUTER JOIN IDENTITY_CODE_METADATA ICM ON ICS.CODE_CONSUMER_ID=ICM.CODE_CONSUMER_ID
AND ICS.CODE_SYSTEM_ID=ICM.CODE_SYSTEM_ID
AND ICS.CODE_SYSTEM_VALUE=ICM.CODE_SYSTEM_VALUE
AND ICM.METADATA_TYPE_ID=1
LEFT OUTER JOIN PROGRAMS ON PROGRAM_CONCEPTS.PROGRAM_ID=PROGRAMS.PROGRAM_ID
WHERE ICS.VALID = 'Y'
