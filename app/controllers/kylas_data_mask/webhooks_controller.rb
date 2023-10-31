# frozen_string_literal: true

module KylasDataMask
  class WebhooksController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    def handler
      ProcessUserWebhookJob.perform_later(request.headers['Api-Key'], params.permit!)

      head :ok
    end
  end
end
