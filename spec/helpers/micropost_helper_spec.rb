# encoding: utf-8
require "spec_helper"

describe MicropostHelper do

  describe "return admin-message if micropost is marked with admin" do
    before {
      @micropost = Micropost.new(content: 'Some content', admin_message: true)
    }
    it { micropost_admin_class(@micropost) == 'admin-message'  }
  end

  describe "return nothing if micropost is not marked with admin" do
    before {
      @micropost = Micropost.new(content: 'Some content', admin_message: false)
    }
    it { micropost_admin_class(@micropost) == '' }
  end

end