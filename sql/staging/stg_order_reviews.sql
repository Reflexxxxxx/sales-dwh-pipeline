TRUNCATE staging.order_reviews;

INSERT INTO staging.order_reviews
SELECT DISTINCT ON (review_id)
    review_id,
    order_id,
    NULLIF(review_score, '')::INTEGER,
    NULLIF(review_comment_title, ''),
    NULLIF(review_comment_message, ''),
    NULLIF(review_creation_date, '')::TIMESTAMP,
    NULLIF(review_answer_timestamp, '')::TIMESTAMP
FROM raw.order_reviews
WHERE review_id <> ''
ORDER BY review_id;
