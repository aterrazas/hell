# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "aterrazas"
client_key               "#{current_dir}/aterrazas.pem"
validation_client_name   "alextech-validator"
validation_key           "#{current_dir}/alextech-validator.pem"
chef_server_url          "https://api.chef.io/organizations/alextech"
cookbook_path            ["#{current_dir}/../cookbooks"]
