SELECT DISTINCT CONSUMER_NAME,
                CODE_SYSTEM_ID,
                CODE_NAME,
                CODE_VALUE,
                MAPPING_STATUS,
                ACTIVITY_COUNT
FROM CONCEPTMAPSUPPORT.CODES_MAPPINGS
WHERE CONSUMER_ID IN (198) <-CLIENT IDENTIFIER
  AND (MAPPING_STATUS !='Validated'
       OR (MAPPING_STATUS='Validated'
           AND CONCEPT_ID IS NULL))
  AND CODE_SYSTEM_ID!='urn:cerner:coding:codingsystem:codeset:93'
  AND CODE_SYSTEM_ID!='urn:cerner:coding:codingsystem:codeset:200'
  AND CODE_SYSTEM_ID!='urn:cerner:coding:codingsystem:nomenclature.source_vocab:GENERAL LAB'
  AND CODE_SYSTEM_ID!='urn:cerner:coding:codingsystem:nomenclature.source_vocab:BLOOD BANK'
  AND CODE_SYSTEM_ID!='urn:cerner:coding:codingsystem:codeset:14003'
  AND CODE_SYSTEM_ID!='urn:cerner:coding:codingsystem:nomenclature.source_vocab:CERNER'
ORDER BY CONSUMER_NAME, (CASE
                             WHEN ACTIVITY_COUNT IS NULL THEN 0
                             ELSE 1
                         END) DESC, ACTIVITY_COUNT DESC
