#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


#case node[:platform]
#  when 'debian', 'ubuntu'
#    include_recipe 'apt'
#end
  
document_root = node['apache']['document_root']

package 'Install Apache' do
  case node[:platform]
    when 'redhat', 'centos', 'amazon'
      package_name ['httpd','git']
    when 'ubuntu', 'debian'
      package_name ['apache2','git']
  end
end

service 'apache' do
  case node[:platform]
    when 'redhat', 'centos', 'amazon'
      service_name 'httpd'
    when 'ubuntu', 'debian'
      service_name 'apache2'
  end
  action [ :enable, :start ]
end

case node[:platform]
  when 'redhat', 'centos', 'amazon'
    cookbook_file '/etc/httpd/conf.d/vhost.conf' do
      source 'centos-vhost.conf'
      owner 'root'
      mode '0655'
      
      notifies :restart, 'service[apache]', :immediately
    end
  when 'ubuntu', 'debian'
    cookbook_file '/etc/apache2/sites-available/000-default.conf' do
      source 'ubuntu-vhost.conf'
      owner 'root'
      mode '0655'
      notifies :restart, 'service[apache]', :immediately
    end
end

deploy 'git_repo' do
  deploy_to document_root
  repo 'git://github.com/mourngrym1969/static.git'
  symlink_before_migrate({})
  create_dirs_before_symlink []
  symlinks Hash.new
  purge_before_symlink ['.git', 'README.md']
end 

 
