require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'tarball class' do

  #http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tarball': }

      tarball::untar { 'tomcat':
        source_url  => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        ln          => '/tomcat',
        ln_file     => 'apache-tomcat-7.0.68',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    # test -f /usr/local/src/tomcat.tar
    it "downloaded file exists" do
      expect(shell("test -f /usr/local/src/tomcat.tar").exit_code).to be_zero
    end

    # ls -s /usr/local/src/tomcat.tar  | awk '{ print $1 }' | grep -v "^0$"
    it "downloaded file with content" do
      expect(shell("ls -s /usr/local/src/tomcat.tar  | awk '{ print $1 }' | grep -v \"^0$\"").exit_code).to be_zero
    end

    # ls -la /tomcat | awk '{ print $NF }' | grep /opt/tomcat/apache-tomcat-7.0.68
    it "softlink target" do
      expect(shell("ls -la /tomcat | awk '{ print $NF }' | grep /opt/tomcat/apache-tomcat-7.0.68").exit_code).to be_zero
    end

    # grep -i apache /tomcat/LICENSE
    it "softlink target + extraction" do
      expect(shell("grep -i apache /tomcat/LICENSE").exit_code).to be_zero
    end

  end
end
