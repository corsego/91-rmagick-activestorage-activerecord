class Post < ApplicationRecord
  has_one_attached :thumbnail

  after_create :attach_thumbnail

  private

  def attach_thumbnail
    GenerateThumbnailService.new(self)
  end
end
