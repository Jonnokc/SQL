--All Validated Codes in all mapping programs (this includes the same code multiple times):

SELECT *
FROM CONCEPTMAPSUPPORT.CODES_MAPPINGS
WHERE MAPPING_STATUS='Validated'
  AND CONSUMER_ID IN (198) --Clients Consumer ID
  AND CONCEPT_ID IS NOT NULL
