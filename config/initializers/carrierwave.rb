#S3_CONFIG = YAML.load_file(Rails.root.join('config', 'amazon_s3.yml'))[Rails.env]

#CarrierWave.configure do |config|
#  config.storage              = :s3
#  config.s3_access_policy     = :public_read
#  config.s3_access_key_id     = S3_CONFIG['']
#  config.s3_secret_access_key = S3_CONFIG['']
#  config.s3_bucket            = S3_CONFIG['']
#  config.fog_public = false
#end

CarrierWave.configure do |config|
	config.fog_credentials = {
		provider: "AWS",
		aws_access_key_id: "",
		aws_secret_access_key: ""
		#:persistent => false #this may not work...
	}
	config.fog_directory = ""
	config.fog_public = false
end
