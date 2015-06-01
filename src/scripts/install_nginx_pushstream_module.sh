#!/usr/bin/env bash

#So download the Nginx source from the ppa repository:
cd /opt


sed -i "s/^\#deb\-src/deb\-src/" /etc/apt/sources.list.d/nginx-stable-trusty.list
apt-get -y update
apt-get -y build-dep nginx
apt-get -y source nginx

#Download one or more modules you want to compile in (we’ll use the push-stream module)
nginx_version=`nginx -v 2>&1 | awk '{print $3}' | cut -d '/' -f 2`
cd /opt/nginx-$nginx_version/debian/modules
git clone https://github.com/wandenberg/nginx-push-stream-module.git
wget http://wiki.nginx.org/images/5/51/Nginx-accesskey-2.0.3.tar.gz
tar xzvf Nginx-accesskey-2.0.3.tar.gz
sed -i 's/$HTTP_ACCESSKEY_MODULE/ngx_http_accesskey_module/' nginx-accesskey-2.0.3/config

#cp /home/vagrant/rules /opt/nginx-$nginx_version/debian/rules

sed -i 's/--add-module=$(MODULESDIR)\/ngx_http_substitutions_filter_module/--add-module=$(MODULESDIR)\/ngx_http_substitutions_filter_module --add-module=$(MODULESDIR)\/nginx-push-stream-module --add-module=$(MODULESDIR)\/nginx-accesskey-2.0.3/' /opt/nginx-$nginx_version/debian/rules


cd /opt/nginx-$nginx_version
dpkg-buildpackage -uc -b

apt-get remove -y nginx

dpkg --install /opt/nginx-full_$nginx_version-1+trusty1_amd64.deb

apt-mark hold nginx-full
