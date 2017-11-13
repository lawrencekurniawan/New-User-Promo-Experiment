WITH users AS (
      SELECT 
        users.user_uuid
        , name AS treatment_group_key
        , created_at 
        , dc.signup_city_id
        , dc.signup_attribution_method
        , dc.is_referral
      
      FROM raw_etl_data.api_user_tags AS users 
      
      JOIN  dwh.dim_client AS dc
        ON dc.user_uuid = users.user_uuid
        AND dc.is_uber_email = FALSE
        --AND dc.country_id = 
      
      WHERE name IN ('indo_sul_rider_promo_t2' 
                    , 'indo_sul_rider_promo_t1' 
                    , 'indo_sul_rider_promo_control' 
                    , 'indo_sul_rider_promo_t4' 
                    , 'indo_sul_rider_promo_t3'
                    , 'indo_sul_rider_promo_t5'
                    , 'indo_sul_rider_promo_t6'
                    , 'indo_sul_rider_promo_t7'
                    , 'indo_sul_rider_promo_t8')
      AND deleted_at IS NULL
)

      SELECT
        ft.uuid AS trip_uuid
        , users.user_uuid
        , dp.promotion_code
        , fpr.amount_used
        , fpr.trip_fare
        , fpr.trip_fare_usd
        , fpr.trip_city_id
        , dp.promotion_value
        , dp.promotion_trips
        , dp.promotion_redemption_limit
        , users.treatment_group_key
        , users.signup_city_id
        , users.signup_attribution_method
        , users.is_referral
        , ft.original_fare_usd
        , CASE WHEN LOWER(ft.flow) LIKE '%moto%' THEN 'Moto' ELSE 'Car' END
        , ft.request_timestamp_local
            
      FROM users 
      
      LEFT JOIN dwh.fact_trip AS ft
        ON ft.client_uuid = users.user_uuid
        AND DATE(ft.request_timestamp_local) > DATE('2017-09-11')
        AND DATE(ft.request_timestamp_local) < DATE('2017-11-12')
        AND LOWER(ft.status) = 'completed'
        AND UPPER(ft.currency_code) = 'IDR'
        
      LEFT JOIN dwh.fact_promo_redeem AS fpr
        ON fpr.trip_uuid = ft.uuid 
        AND CAST(fpr.apply_timestamp AS TIMESTAMP) > CAST('2017-09-01' AS TIMESTAMP)
        
      LEFT JOIN dwh.dim_promotion AS dp
        ON fpr.promotion_code_uuid = dp.promotion_code_uuid 
