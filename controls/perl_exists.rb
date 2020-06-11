title 'Tests to confirm perl exists'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'perl')

control 'core-plans-perl-exists' do
  impact 1.0
  title 'Ensure perl exists'
  desc '
  Verify perl by ensuring bin/perl exists'
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
  end

  command_relative_path = input('command_relative_path', value: 'bin/perl')
  command_full_path = File.join(plan_installation_directory.stdout.strip, "#{command_relative_path}")
  describe file(command_full_path) do
    it { should exist }
  end
end
