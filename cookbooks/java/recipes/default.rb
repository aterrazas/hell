#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

jdk = node['jdk']['version']
jdk_home = ''

case node[:platform]
  when 'redhat', 'centos', 'amazon'
    rpm_package "#{jdk}" do
	package_name "#{jdk}.rpm"
	source "/tmp/#{jdk}.rpm"
    end
    
  when 'ubuntu', 'debian'
    cookbook_file "/tmp/#{jdk}.tar.gz" do
      source "#{jdk}.tar.gz"
      mode '0755'
      action :create_if_missing
    end
    directory '/opt/jdk' do
      mode '0755'
      action :create
    end
    ruby_block "get target dir name" do
      block do
#        #tricky way to load this Chef::Mixin::ShellOut utilities
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = 'tar -tvf /tmp/#{jdk}.tar.gz | head -1 | awk {\'print $6\'}'
        command_out = shell_out(command)
        jdk_home = command_out.stdout
      end
      action :create
    end 
    log jdk_home

#    bash 'install_java' do
#      user 'root'
#      cwd '/tmp'
#      code <<-EOH
#        export jdk_dir="$(tar -tvf /tmp/#{jdk}.tar.gz | head -1 | awk {'print $6'})"
#        sudo tar -xvf #{jdk}.tar.gz -C /opt/jdk/
#        sudo update-alternatives --install /usr/bin/java java /opt/jdk/\"$jdk_dir\"bin/java 100
#        sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/\"$jdk_dir\"bin/javac 100
#      EOH
#      #notifies :run, 'ruby_block[jdk_home]', :immediately
#      not_if not_if {"`/usr/bin/java --version`" == ''}' 
#    end
end
