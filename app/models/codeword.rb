class Codeword < ActiveRecord::Base
  attr_accessible :codeword

  validates :codeword, presence: true, length: {maximum: 50}

end
