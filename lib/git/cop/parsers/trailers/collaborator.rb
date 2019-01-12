# frozen_string_literal: true

module Git
  module Cop
    module Parsers
      module Trailers
        class Collaborator
          DEFAULT_KEY_PATTERN = /\ACo.*Authored.*By.*\Z/i.freeze

          DEFAULT_MATCH_PATTERN = /
            (?<key>\A.+)         # Key (anchored to start of line).
            \:                   # Key delimiter.
            \s?                  # Space delimiter (optional).
            (?<name>.*?)         # Collaborator name (smallest possible).
            \s?                  # Space delimiter (optional).
            (\<(?<email>.+)\>)?  # Collaborator email (optional).
            \Z                   # End of line.
          /x.freeze

          def initialize text,
                         key_pattern: DEFAULT_KEY_PATTERN,
                         match_pattern: DEFAULT_MATCH_PATTERN

            @text = String text
            @key_pattern = key_pattern
            @match_pattern = match_pattern
            @matches = build_matches
          end

          def key
            String matches["key"]
          end

          def name
            String matches["name"]
          end

          def email
            String matches["email"]
          end

          def match?
            text.match? key_pattern
          end

          private

          attr_reader :text, :key_pattern, :match_pattern, :matches

          def build_matches
            text.match(match_pattern).then { |data| data ? data.named_captures : Hash.new }
          end
        end
      end
    end
  end
end
