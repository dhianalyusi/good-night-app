require 'rails_helper'
require 'rswag/specs'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Good Night App API',
        version: 'v1'
      },
      paths: {}
    }
  }

  config.swagger_format = :yaml
end
