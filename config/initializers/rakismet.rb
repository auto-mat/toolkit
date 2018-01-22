akismet_file = Rails.root.join('config', 'akismet')
if akismet_file.exist?
  Cyclescape::Application.config.rakismet.key = akismet_file.read.strip
  Cyclescape::Application.config.rakismet.url = 'http://www.cyklistesobe.cz/'
elsif ['development', 'test'].include? Rails.env
  Cyclescape::Application.config.rakismet.key = 'development'
  Cyclescape::Application.config.rakismet.url = 'http://www.cyklistesobe.cz/'
end
