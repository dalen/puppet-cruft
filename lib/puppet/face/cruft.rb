require 'puppet/face'
require 'puppet/util/storage'

Puppet::Face.define(:cruft, '0.1.0') do
  license "Apache-2.0"
  copyright "Erik Dalén", 2016
  author "Erik Dalén <erik.gustav.dalen@gmail.com>"
  summary "Find resources managed by puppet in the past but not anymore."
  action :list do
    default
    summary "List resources"
    description <<-'EOT'
      List
    EOT
    returns <<-'EOT'
      A hash
    EOT
    when_invoked do |*args|
      Puppet::Util::Storage.load
      state = Puppet::Util::Storage.state
      resource_refs = Puppet::Resource::Catalog.indirection.find(Puppet[:certname]).resource_refs

      state.reject do |resource, _|
        resource_refs.include? resource
      end.reject do |resource, _|
        resource.to_s.start_with? 'Schedule[', 'Class[', 'Stage[', 'Node['
      end.keys
    end
  end
end
