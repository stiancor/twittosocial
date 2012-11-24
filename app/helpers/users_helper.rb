module UsersHelper

  # Returns the Gravatar for the given user
  def gravatar_for(user, options = {size: 50, image_icon: 'monsterid'})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}&d=#{options[:image_icon]}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def non_existing_codeword?(codeword)
    if Codeword.find_by_codeword(codeword.codeword).nil?
      codeword.errors.add(:codeword, "is needed to create a user. Only the chosen ones will have it")
    end
  end

  def has_errors_in_any_objects?(array)
    array.any? { |model| model.errors.any? }
  end

end
