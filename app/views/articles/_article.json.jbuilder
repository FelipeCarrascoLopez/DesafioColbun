json.extract! article, :id, :headline, :lead, :body, :created_at, :updated_at
json.url article_url(article, format: :json)
