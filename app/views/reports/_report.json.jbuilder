json.extract! report, :id, :title, :date, :content, :created_at, :updated_at
json.url report_url(report, format: :json)
