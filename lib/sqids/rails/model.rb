class Sqids
  module Rails
    module Model
      class AlphabetError < StandardError; end
      class MinimumLengthError < StandardError; end

      extend ActiveSupport::Concern

      included do
        # Store sqid configurations at the class level
        class_attribute :sqid_configurations, default: {}
      end

      module ClassMethods
        # Define a sqid attribute that dynamically encodes the record ID
        #
        # Example:
        #
        #   class User < ApplicationRecord
        #     include Sqids::Rails::Model
        #
        #     has_sqid
        #     has_sqid :long_sqid, min_length: 24
        #   end
        #
        #   user = User.create!
        #   user.id # => 1
        #   user.sqid # => "lzNKgEb6ZuaU" (dynamically encoded ID)
        #   user.long_sqid # => "4y3SVm9M2aV8Olu6p4zZoGij" (dynamically encoded ID with min_length 24)
        #
        #   # Find a user by sqid
        #   User.find_by_sqid("lzNKgEb6ZuaU") # => #<User id: 1>
        #   User.find_by_sqid!("lzNKgEb6ZuaU") # => #<User id: 1>
        #   User.find_by_sqid("4y3SVm9M2aV8Olu6p4zZoGij", :long_sqid) # => #<User id: 1>
        #
        # See the {Sqids Ruby}[https://github.com/sqids/sqids-ruby] documentation for more information on the options.
        #
        # === Options
        #
        # [:alphabet]
        #   The alphabet to use for encoding. Default is +Sqids::Rails.alphabet+.
        #   The minimum alphabet length is 3 characters.
        #   The alphabet cannot contain any multibyte characters.
        #
        # [:blocklist]
        #   The blocklist to use for encoding. Default is +Sqids::Rails.blocklist+.
        #
        # [:min_length]
        #   The minimum length of the generated sqid, from 0-255. Default is +Sqids::Rails.min_length+.
        def has_sqid(
          attribute = :sqid,
          alphabet: Sqids::Rails.alphabet,
          blocklist: Sqids::Rails.blocklist,
          min_length: Sqids::Rails.min_length
        )
          validate_sqid_options(alphabet, min_length)

          # Store configuration for this attribute
          self.sqid_configurations = sqid_configurations.merge(
            attribute.to_sym => {
              alphabet: alphabet,
              blocklist: blocklist,
              min_length: min_length
            }
          )

          # Define the accessor method that generates the sqid on-the-fly
          define_method(attribute) do
            return nil unless persisted?

            # Use instance variable to memoize sqid instances per attribute
            sqids_variable = "@_sqids_instance_for_#{attribute}"

            unless instance_variable_defined?(sqids_variable)
              config = self.class.sqid_configurations[attribute.to_sym]

              instance_variable_set(sqids_variable, Sqids.new(
                alphabet: config[:alphabet],
                blocklist: config[:blocklist],
                min_length: config[:min_length]
              ))
            end

            # Use the memoized instance
            instance_variable_get(sqids_variable).encode([ id ])
          end

          # Define a URL-friendly alias to the ID
          define_method(:"to_param") do
            # Use the default sqid as the URL parameter
            send(:sqid)
          end if attribute == :sqid
        end

        # Find a record by its sqid
        def find_by_sqid(sqid, attribute = :sqid)
          return nil if sqid.nil? || sqid.empty?

          config = sqid_configurations[attribute.to_sym]
          raise ArgumentError, "No sqid configuration found for attribute '#{attribute}'" unless config

          sqids_instance = Sqids.new(
            alphabet: config[:alphabet],
            blocklist: config[:blocklist],
            min_length: config[:min_length]
          )

          # Decode the sqid to get the original ID
          decoded_ids = sqids_instance.decode(sqid)
          return nil if decoded_ids.empty?

          # Find by the original ID
          find_by(id: decoded_ids.first)
        end

        # Find a record by its sqid or raise ActiveRecord::RecordNotFound
        def find_by_sqid!(sqid, attribute = :sqid)
          record = find_by_sqid(sqid, attribute)
          raise ActiveRecord::RecordNotFound, "Couldn't find #{name} with sqid=#{sqid}" unless record
          record
        end

        private

          def validate_sqid_options(alphabet, min_length)
            if alphabet.length < 3
              raise AlphabetError, "Sqid requires an alphabet of at least 3 characters"
            end

            if alphabet.each_char.any? { |char| char.bytesize > 1 }
              raise AlphabetError, "Sqid alphabet cannot contain multibyte characters"
            end

            if alphabet.chars.uniq.length != alphabet.length
              raise AlphabetError, "Sqid alphabet must contain unique characters"
            end

            if min_length < 0 || min_length > 255
              raise MinimumLengthError, "Sqid requires a minimum length between 0 and 255 characters"
            end
          end
      end
    end

    # Extend CollectionProxy to support find_by_sqid through associations
    module CollectionProxyMethods
      def find_by_sqid(sqid, attribute = :sqid)
        klass.find_by_sqid(sqid, attribute)
      end

      def find_by_sqid!(sqid, attribute = :sqid)
        klass.find_by_sqid!(sqid, attribute)
      end
    end
  end
end
