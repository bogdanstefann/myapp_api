class ArticleSerializer
  include JSONAPI::Serializer
  attributes :title, :body

  attribute :published do |object|
    object.title.length > 5
  end
end
