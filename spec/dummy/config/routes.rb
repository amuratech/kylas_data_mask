# frozen string literal: true

Rails.application.routes.draw do
  root to: 'application#index'

  mount KylasDataMask::Engine, at: '/kylas-data-mask'
end
