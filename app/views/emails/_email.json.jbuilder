json.extract! email, :id, :to_name, :from_name, :to_email, :from_email, :subject, :created_at, :updated_at
json.url email_url(email, format: :json)
