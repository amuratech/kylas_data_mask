# frozen_string_literal: true

KylasDataMask::Engine.routes.draw do
  post '/webhooks/handler', to: 'webhooks#handler'
end
