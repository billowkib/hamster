require "spec_helper"

require "hamster/hash"

describe Hamster::Hash do

  describe "#marshal_dump/#marshal_load" do

    let(:ruby) { File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"]) }

    let(:child_cmd) do
      %Q|#{ruby} -I lib -r hamster -e 'dict = Hamster.hash existing_key: 42, other_thing: "data"; $stdout.write(Marshal.dump(dict))'|
    end

    let(:reloaded_hash) do
      IO.popen(child_cmd, "r+") do |child|
        reloaded_hash = Marshal.load(child)
        child.close
        reloaded_hash
      end
    end



    it "should survive dumping and loading into a new process" do
      reloaded_hash.should == Hamster.hash(existing_key: 42, other_thing: "data")
    end

    it "should still be possible to find items by key" do
      reloaded_hash[:existing_key].should == 42
    end

  end

end
