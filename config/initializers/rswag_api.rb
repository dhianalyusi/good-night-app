# Configure rswag-api to find generated Swagger files
if defined?(Rswag::Api)
  Rswag::Api.configure do |c|
    # Directory where rswag will output swagger JSON/YAML files
    c.swagger_root = Rails.root.join("swagger").to_s
  end
end
