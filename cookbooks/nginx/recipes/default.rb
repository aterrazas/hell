#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


case node[:platform]
  when 'debian', 'ubuntu'
    include_recipe 'apt'
  when 'redhat', 'centos', 'amazon'
    include_recipe 'yum-epel'  
end
  

package ['nginx','git']


service 'nginx' do
  service_name 'nginx'
  action [ :enable, :start ]
end

cookbook_file '/etc/nginx/conf.d/virtual.conf' do
  source 'centos-virtual.conf'
  owner 'root'
  mode '0655'
  notifies :restart, 'service[nginx]', :immediately
end

document_root = node['nginx']['document_root']

deploy 'git_repo' do
  deploy_to document_root
  repo 'git://github.com/mourngrym1969/static.git'
  symlink_before_migrate({})
  create_dirs_before_symlink []
  symlinks Hash.new
  purge_before_symlink ['.git', 'README.md']
end 


