%w(
  libxml2-devel
  libxslt-devel
  libcurl-devel
  python-devel
  bzip2-devel
  gcc-c++
  gcc-gfortran
  atlas-sse3
  atlas-sse3-devel
  blas
  lapack
  fontconfig
  libpng
  man
  lighttpd
  lighttpd-fastcgi
  vim
  git-svn
).each do |package|
  yum_package package
end

python_pip 'virtualenv'
python_pip 'pexpect' do
  virtualenv '/home/vagrant/env/dm' # untested!
end

python_virtualenv '/home/vagrant/env/dm' do
  options '--distribute --prompt=\(datamapper\)'
end

bash 'install stuff' do
  user 'root'
  code <<-END
    if [ ! -f /home/vagrant/dm_setup.done ]; then
      pushd /tmp
      wget http://www.selenic.com/smem/download/smem-1.3.tar.gz
      gunzip smem-1.3.tar.gz
      tar xvf smem-1.3.tar -C /usr/local/bin
      ln -s /usr/local/bin/smem-1.3/smem /usr/local/bin/smem
      popd
      
      . /home/vagrant/env/dm/bin/activate

      /home/vagrant/env/dm/bin/pip install -r /home/vagrant/code/dm/requirements.txt

      rpm -i http://3rdparty.dev.tripit.com/newRPMS/x86_64/antiword-it-0.37-itinerator.30727.rhel5.x86_64.rpm
      rpm -i http://3rdparty.dev.tripit.com/newRPMS/x86_64/ms-rtf-0.1.0-itinerator.30411.rhel5.x86_64.rpm
      rpm -i http://3rdparty.dev.tripit.com/newRPMS/x86_64/poppler-it-0.14.5-itinerator.31009.rhel5.x86_64.rpm
      rpm -i http://3rdparty.dev.tripit.com/newRPMS/x86_64/chroot_safe-1.4-itinerator.13103.rhel5.x86_64.rpm
    fi

    touch /home/vagrant/dm_setup.done
  END
end

template '/home/vagrant/.bashrc' do
  source '.bashrc.erb'
  mode '0644'
end
