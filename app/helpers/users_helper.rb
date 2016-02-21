module UsersHelper

  # Returns the Gravatar for the given user
  def gravatar_for(user, options = {size: 50, image_icon: 'monsterid'})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}&d=#{options[:image_icon]}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def existing_codeword?(codeword)
    exist = Codeword.where('codeword = ?', codeword.codeword).to_a.size > 0
    unless exist
      codeword.errors.add(:codeword, "is needed to create a user. Only the chosen ones will have it")
    end
    exist
  end

end
