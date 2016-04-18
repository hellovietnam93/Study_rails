Cloudinary.config do |config|
  config.cloud_name = ENV["CLOUDNAME"]
  config.api_key = ENV["APP_KEY"]
  config.api_secret = ENV["APP_SECRET"]
  config.cdn_subdomain = true
  enhance_image_tag = true
  static_image_support = true
end
