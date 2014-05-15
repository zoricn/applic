CarrierWave.configure do |config|

  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => Settings.s3.aws_access_key_id,                        # required
    :aws_secret_access_key  => Settings.s3.aws_secret_access_key,                        # required
    :region                 => 'eu-west-1'#,                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.example.com',             # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = Settings.s3.bucket                   # required
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}

  #config.asset_host     = "http://#{AppSettings.s3_bucket}.s3-eu-west-1.amazonaws.com"            # optional, defaults to nil
  
  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.cache_dir = Rails.env.development? ? Rails.root.to_s + '/public/uploads/tmp' : "/data/#{Rails.env}/tmp/" 
  end



end