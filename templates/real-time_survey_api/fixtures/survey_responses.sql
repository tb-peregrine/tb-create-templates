SELECT
    concat('resp_', toString(rand() % 10000)) AS response_id,
    concat('surv_', toString(rand() % 100)) AS survey_id,
    concat('user_', toString(rand() % 5000)) AS user_id,
    now() - toIntervalDay(rand() % 30) AS timestamp,
    arrayMap(x -> concat('question_', toString(x)), range(1, 3 + rand() % 3)) AS questions,
    arrayMap(x -> concat('answer_', toString(x)), range(1, 3 + rand() % 3)) AS answers,
    1 + rand() % 10 AS rating,
    multiIf(
        rand() % 3 = 0, 'Very satisfied with the product!',
        rand() % 3 = 1, 'Could use some improvements.',
        'The service was okay, but not exceptional.'
    ) AS feedback,
    arrayMap(x -> ['important', 'urgent', 'feature', 'bug', 'suggestion'][(rand() % 5) + 1], range(1, 1 + rand() % 3)) AS tags
FROM numbers(10)