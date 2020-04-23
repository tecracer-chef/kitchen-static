source "https://rubygems.org"

gemspec

group :development do
  gem "chefstyle", git: "https://github.com/chef/chefstyle.git", branch: "master"
end

group :debug do
  gem "pry"
  gem "guard"
  gem "guard-rake"
end

# If you want to load debugging tools into the bundle exec sandbox,
# add these additional dependencies into Gemfile.local
eval_gemfile(__FILE__ + ".local") if File.exist?(__FILE__ + ".local")
