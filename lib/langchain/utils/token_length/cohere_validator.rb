# frozen_string_literal: true

module Langchain
  module Utils
    module TokenLength
      #
      # This class is meant to validate the length of the text passed in to Cohere's API.
      # It is used to validate the token length before the API call is made
      #

      class CohereValidator < BaseValidator
        TOKEN_LIMITS = {
          # Source:
          # https://docs.cohere.com/docs/models
          "command-light" => 4096,
          "command" => 4096,
          "base-light" => 2048,
          "base" => 2048,
          "embed-english-light-v2.0" => 512,
          "embed-english-v2.0" => 512,
          "embed-multilingual-v2.0" => 256,
          "summarize-medium" => 2048,
          "summarize-xlarge" => 2048
        }.freeze

        #
        # Calculate token length for a given text and model name
        #
        # @param text [String] The text to calculate the token length for
        # @param model_name [String] The model name to validate against
        # @return [Integer] The token length of the text
        #
        def self.token_length(text, model_name, client)
          res = client.tokenize(text: text)
          res["tokens"].length
        end

        def self.token_limit(model_name)
          TOKEN_LIMITS[model_name]
        end
        singleton_class.alias_method :completion_token_limit, :token_limit

        def self.token_length_from_messages(messages, model_name, options)
          messages.sum { |message| token_length(message.to_json, model_name, options) }
        end
      end
    end
  end
end
