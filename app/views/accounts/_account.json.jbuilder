json.extract! account, :id, :email, :is_active, :plan_tier, :created_at, :updated_at
json.url account_url(account, format: :json)
