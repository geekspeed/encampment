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


# I detest using hardcoded bash for this
# BUT I detested reverse engineering the chef to install these rpms even more
# ALSO this:
# python_pip '/home/vagrant/code/dm' do
#   virtualenv '/home/vagrant/env/dm'
# end
# DID NOT work, it seems to ignore the virtualenv attribute
# maybe I did it wrong, but I moved it into the script to get on with life
bash 'install stuff' do
  user 'root'
  code <<-END
    if [ ! -f /home/vagrant/dm_setup.done ]; then
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
