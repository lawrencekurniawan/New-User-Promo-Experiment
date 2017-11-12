SELECT user_uuid
      , name AS treatment_group_key
      , created_at 
      
      FROM raw_etl_data.api_user_tags 
      
      WHERE name IN ('indo_sul_rider_promo_t2' 
      , 'indo_sul_rider_promo_t1' 
      , 'indo_sul_rider_promo_control' 
      , 'indo_sul_rider_promo_t4' 
      , 'indo_sul_rider_promo_t3'
      , 'indo_sul_rider_promo_t5'
      , 'indo_sul_rider_promo_t6'
      , 'indo_sul_rider_promo_t7'
      , 'indo_sul_rider_promo_t8'