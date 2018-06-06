class SignatureUploader < CarrierWave::Uploader::Base

  storage :aws

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  #version :thumb do
  #  process resize_to_fit: [50, 50]
  #end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
