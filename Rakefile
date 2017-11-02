require 'cucumber/rake/task'

namespace :features do
  Cucumber::Rake::Task.new(:core) do |t|
    t.cucumber_opts = "-r features/core/ -t ~@ui_only"
  end

  Cucumber::Rake::Task.new(:e2e) do |t|
    t.cucumber_opts  = "-r features/e2e/"
  end
end
