module AdminHelper
  def image_generator(height:, width:)
    "http://via.placeholder.com/#{height}x#{width}"
  end
  
  def user_signature img, type
    if img.model.signature?
      img
    end
  end
end
