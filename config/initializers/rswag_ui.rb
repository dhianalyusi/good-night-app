# Configure the rswag UI swagger endpoint if rswag is available
if defined?(Rswag::Ui)
  Rswag::Ui.configure do |c|
    # Serve the v1 spec at /api-docs/v1/swagger.yaml
    c.swagger_endpoint "/api-docs/v1/swagger.yaml", "API V1 Docs"
  end
end
