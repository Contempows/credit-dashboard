class ReceiptUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def download_url(filename)
    url(response_content_disposition: %(attachment; filename="#{filename}"))
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def url
    S3 + "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/#{model.attachment.file.filename}"
  end

  def purchase_url(attachment_type)
    case attachment_type
    when :file_for_ssn
      S3 +
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/" \
        "#{model.file_for_ssn.file.filename}"
    when :file_for_dl
      S3 +
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/" \
        "#{model.file_for_dl.file.filename}"
    when :file_for_special_add
      S3 +
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/" \
        "#{model.file_for_special_add.file.filename}"
    end
  end

  def extension_whitelist
    %w[jpg jpeg png gif ico pdf]
  end
end
