module Qa
  class DbController < ApplicationController
    skip_before_filter :authenticate_user!
    before_filter :basic_authenticate

    def reset
      system "bundle exec rake db:reset"
      render text: "db reset."
    end
  end
end