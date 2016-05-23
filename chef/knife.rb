# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'USERNAME'
client_key               "#{current_dir}/jray_chef.pem"
validation_client_name   'gps-ocx-ifdc-validator'
validation_key           "#{current_dir}/gps-ocx-ifdc-validator.pem"
chef_server_url          'https://chef-server/organizations/gps-ocx-ifdc'
cookbook_path            ["#{current_dir}/../dev/chef/"]
ssl_verify_mode          :verify_none
chefdk.generator_cookbook "#{current_dir}/code_generator"
