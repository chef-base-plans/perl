title 'Tests to confirm perl works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'perl')

control 'core-plans-perl-works' do
  impact 1.0
  title 'Ensure perl works as expected'
  desc '
  Verify perl by ensuring 
  (1) its installation directory exists and 
  (2) that it returns the expected version.
  (3) that it runs a perl script successfull
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
  end
  
  command_relative_path = input('command_relative_path', value: 'bin/perl')
  command_full_path = File.join(plan_installation_directory.stdout.strip, "#{command_relative_path}")
  plan_pkg_version = plan_installation_directory.stdout.split("/")[5]
  describe command("#{command_full_path} --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /This is perl 5.+\(v(?<version>#{plan_pkg_version})/ }
    its('stderr') { should be_empty }
  end

  describe command("#{command_full_path} -e 'print \"Hello, World!\n\"'") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Hello, World!/ }
    its('stderr') { should be_empty }
  end
end