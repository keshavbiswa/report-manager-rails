module AdminHelper
  def image_generator(height:, width:)
    "http://via.placeholder.com/#{height}x#{width}"
  end
  
  def user_signature img, type
    if img.model.signature?
      img
    end
  end

  def roles_helper user
    str = ""
    if user.roles.count <= 1
      str = "#{user.role}".capitalize
    else
      user.roles.each do |role|
        if user.roles.last == role
          str << "#{role.to_s}".capitalize
        else
          str << "#{role.to_s},".capitalize + " "
        end
      end
    end
    str
  end
end
