# Install Chef-Run handlers
#
include_recipe 'chef_handler::default'

path = ::File.join(node['chef_handler']['handler_path'], 'cfn_signal.rb')
cookbook_file path do
  source 'chef_handlers/cfn_signal.rb'
  mode '0644'
end

chef_handler 'CFN::CloudFormationSignalHandler' do
  source path
  arguments lazy {
    {
      region:     node['cfn']['vpc']['region_id'],
      stack_name: node['cfn']['stack']['stack_name'],
      logical_id: node['cfn']['stack']['logical_id'],
      unique_id:  node['ec2']['instance_id']
    }
  }
  action node['cfn']['tools']['signal_cloudformation'] ? :enable : :disable
  only_if do
    node['cfn']['stack']['logical_id'] rescue false
  end
end
