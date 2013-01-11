OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,'223258061139433', '50a03ac69acd204da05905552eab4826', {:client_options => {:ssl => {:ca_file => "#{Rails.root}/config/ca-bundle.crt"}}}
end