# =========================================================
# this model is used to modify Rails template content using
# inverter gem
# ---------------------------------------------------------
class Page
  include Mongoid::Document
  # include Mongoid::SerializableId
  include Mongoid::Inverter
  include Mongoid::Slug
  # include Mongoid::Orderable

  # attributes
  field :_scope,         type: String
  field :hero_image_url, type: String, default: ''
end




