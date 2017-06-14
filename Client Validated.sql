--All Validated Codes in all mapping programs (this includes the same code multiple times):

SELECT DISTINCT CONSUMER_NAME AS "CONSUMER",
                CODE_SYSTEM_NAME AS "CODE SYSTEM",
                CODE_NAME AS "CODE_NAME",
                CODE_VALUE AS "CODE ID",
                VOCABULARY_NAME AS "VOCABULARY",
                VOCABULARY_ID AS "OIDs",
                CONCEPT_ID AS "CONCEPT ID",
                CONCEPT_NAME AS "CONCEPT NAME",
                MAPPING_STATUS AS "MAPPING STATUS"
FROM CONCEPTMAPSUPPORT.CODES_MAPPINGS
WHERE MAPPING_STATUS='Validated'
  AND CONSUMER_ID IN (143,
                      695,
                      503)-- Consumer ID
AND CONCEPT_ID IS NOT NULL
