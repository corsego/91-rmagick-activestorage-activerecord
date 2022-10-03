class GenerateThumbnailService
  require 'RMagick'
  include Magick

  attr_reader :post

  def initialize(post)
    @post = post
    call
  end

  def call
    image = Magick::Image.new(800, 400) do |img|
      img.background_color = 'yellow'
    end

    logo_path = Rails.root.join('app/assets/images/logo.png')
    logo = Magick::Image.read(logo_path).first
    logo = logo.scale(0.2)
    image = image.composite(logo, SouthEastGravity, 5, 5, OverCompositeOp)

    text = Magick::Draw.new
    text.annotate(image, 0, 0, 0, -50, post.title) do |txt|
      txt.pointsize = 48
      txt.font_weight = BoldWeight
      txt.fill = 'blue'
      txt.gravity = CenterGravity
    end

    text.annotate(image, 0, 0, 0, 50, post.body) do |txt|
      txt.pointsize = 24
      txt.font_weight = NormalWeight
      txt.fill = 'green'
      txt.gravity = CenterGravity
    end

    filename = [post.model_name.human, post.id].join.downcase
    # FileUtils.mkdir_p 'app/assets/images/generator'
    image.write("app/assets/images/generator/#{filename}.png")

    image_io = File.open("app/assets/images/generator/#{filename}.png")
    post.thumbnail.attach(io: image_io, filename:, content_type: 'image/png')

    File.delete(image_io)
  end
end
