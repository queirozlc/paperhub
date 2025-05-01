# require "active_support/concern"
# require "active_support/core_ext/module/delegation"
# require "sqids"
# require "active_record/associations/collection_proxy"
#
#
# class Sqids
#   module Rails
#     module FinderMethods
#       extend ActiveSupport::Concern
#
#       included do
#         # This will store our sqid_attribute mappings
#         class_attribute :sqid_attributes, default: {}
#       end
#
#       module ClassMethods
#         # Find a record by its sqid
#         # Usage: User.find_by_sqid('lzNKgEb6ZuaU')
#         def find_by_sqid(sqid, attribute = :sqid)
#           # Get the configuration for this attribute
#           config = sqid_attributes[attribute.to_sym]
#
#           raise ArgumentError, "No sqid configuration found for attribute '#{attribute}'" unless config
#
#           # Decode the sqid to get the original ID
#           sqids_instance = Sqids.new(
#             alphabet: config[:alphabet],
#             blocklist: config[:blocklist],
#             min_length: config[:min_length]
#           )
#
#           decoded_ids = sqids_instance.decode(sqid)
#           return nil if decoded_ids.empty?
#
#           # Find by the original ID
#           find_by(id: decoded_ids.first)
#         end
#
#         # Find a record by its sqid or raise ActiveRecord::RecordNotFound
#         # Usage: User.find_by_sqid!('lzNKgEb6ZuaU')
#         def find_by_sqid!(sqid, attribute = :sqid)
#           record = find_by_sqid(sqid, attribute)
#           raise ActiveRecord::RecordNotFound, "Couldn't find #{name} with sqid=#{sqid}" unless record
#           record
#         end
#
#         # Capture the sqid configuration when has_sqid is called
#         def has_sqid(
#           attribute = :sqid,
#           alphabet: Sqids::Rails.alphabet,
#           blocklist: Sqids::Rails.blocklist,
#           min_length: Sqids::Rails.min_length,
#           on: Sqids::Rails.generate_sqid_on
#         )
#           # Store the configuration for later use in find_by_sqid
#           self.sqid_attributes = sqid_attributes.merge(
#             attribute.to_sym => {
#               alphabet: alphabet,
#               blocklist: blocklist,
#               min_length: min_length
#             }
#           )
#
#           # Call the original has_sqid method
#           super
#         end
#       end
#     end
#
#     # Extend CollectionProxy to support find_by_sqid through associations
#     module CollectionProxyMethods
#       def find_by_sqid(sqid, attribute = :sqid)
#         klass.find_by_sqid(sqid, attribute)
#       end
#
#       def find_by_sqid!(sqid, attribute = :sqid)
#         klass.find_by_sqid!(sqid, attribute)
#       end
#     end
#   end
# end
