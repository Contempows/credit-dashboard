class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def full_url
    S3 + [store_dir, model.profile.file.filename].join('/')
  end

  def url
    S3 + [store_dir, "thumb_#{model.profile.file.filename}"].join('/')
  end

  def fixed_height_url
    S3 + [store_dir, "fixed_height_#{model.profile.file.filename}"].join('/')
  end

  version :thumb do
    process resize_to_limit: [383, -1]
  end

  version :fixed_height do
    process resize_to_limit: [380, 146]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
