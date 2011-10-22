namespace :user do
  desc "Deactivates expired user accounts"
  task :deactivate_expired_accounts => :environment do
    User.deactivate_expired_accounts
    p "done."
  end
end
