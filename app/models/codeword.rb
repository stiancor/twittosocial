class Codeword < ActiveRecord::Base

  validates :codeword, presence: true, length: {maximum: 50}

end
