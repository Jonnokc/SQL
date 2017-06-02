--Replace <client> with client mnemonic
--Replace <POP_ID> with population id

SELECT FULLY_QUALIFIED_NAME,
       COUNT(CASE
                 WHEN STATE = 'MET' THEN EMPI_ID
                 ELSE NULL
             END) AS PERSONS_MET,
       (COUNT(CASE
                  WHEN STATE = 'MET' THEN EMPI_ID
                  ELSE NULL
              END) + COUNT(CASE
                               WHEN STATE = 'NOT_MET_DATA_AVAILABLE' THEN EMPI_ID
                               ELSE NULL
                           END) + COUNT(CASE
                                            WHEN STATE = 'NOT_MET_NO_DATA' THEN EMPI_ID
                                            ELSE NULL
                                        END)) AS PERSONS_INCLUDED,
       COUNT(CASE
                 WHEN STATE = 'MET' THEN EMPI_ID
                 ELSE NULL
             END) / ((COUNT(CASE
                                WHEN STATE = 'MET' THEN EMPI_ID
                                ELSE NULL
                            END) + COUNT(CASE
                                             WHEN STATE = 'NOT_MET_DATA_AVAILABLE' THEN EMPI_ID
                                             ELSE NULL
                                         END) + COUNT(CASE
                                                          WHEN STATE = 'NOT_MET_NO_DATA' THEN EMPI_ID
                                                          ELSE NULL
                                                      END))) AS MET_PERCENTAGE
FROM <CLIENT>.PH_F_MEASURE_OUTCOME
WHERE POPULATION_ID = '<POP_ID>'
GROUP BY FULLY_QUALIFIED_NAME
