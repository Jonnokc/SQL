--Replace <client> with client mnemonic
--Replace <POP_ID> with population id

SELECT fully_qualified_name,
       count(CASE
                 WHEN STATE = 'MET' THEN empi_id
                 ELSE NULL
             END) AS persons_met,
       (count(CASE
                  WHEN STATE = 'MET' THEN empi_id
                  ELSE NULL
              END) + count(CASE
                               WHEN STATE = 'NOT_MET_DATA_AVAILABLE' THEN empi_id
                               ELSE NULL
                           END) + count(CASE
                                            WHEN STATE = 'NOT_MET_NO_DATA' THEN empi_id
                                            ELSE NULL
                                        END)) AS persons_included,
       count(CASE
                 WHEN STATE = 'MET' THEN empi_id
                 ELSE NULL
             END) / ((count(CASE
                                WHEN STATE = 'MET' THEN empi_id
                                ELSE NULL
                            END) + count(CASE
                                             WHEN STATE = 'NOT_MET_DATA_AVAILABLE' THEN empi_id
                                             ELSE NULL
                                         END) + count(CASE
                                                          WHEN STATE = 'NOT_MET_NO_DATA' THEN empi_id
                                                          ELSE NULL
                                                      END))) AS met_percentage
FROM <client>.ph_f_measure_outcome
WHERE population_id = '<POP_ID>'
GROUP BY fully_qualified_name
