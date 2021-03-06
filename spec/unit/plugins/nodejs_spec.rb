#
# Author:: Jacques Marneweck (<jacques@powertrip.co.za>)
# Copyright:: Copyright (c) Jacques Marneweck
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '/spec_helper.rb'))

describe Ohai::System, "plugin nodejs" do

  before(:each) do
    @ohai = Ohai::System.new
    @ohai[:languages] = Mash.new
    @ohai.stub!(:require_plugin).and_return(true)
    @status = 0
    @stdout = "v0.8.11\n"
    @stderr = ""
    @ohai.stub!(:run_command).with({:no_status_check=>true, :command=>"node -v"}).and_return([@status, @stdout, @stderr])
  end

  it "should get the nodejs version from running node -v" do
    @ohai.should_receive(:run_command).with({:no_status_check=>true, :command=>"node -v"}).and_return([0, "v0.8.11\n", ""])
    @ohai._require_plugin("nodejs")
  end

  it "should set languages[:nodejs][:version]" do
    @ohai._require_plugin("nodejs")
    @ohai.languages[:nodejs][:version].should eql("0.8.11")
  end

  it "should not set the languages[:nodejs] tree up if node command fails" do
    @status = 1
    @stdout = "v0.8.11\n"
    @stderr = ""
    @ohai.stub!(:run_command).with({:no_status_check=>true, :command=>"node -v"}).and_return([@status, @stdout, @stderr])
    @ohai._require_plugin("nodejs")
    @ohai.languages.should_not have_key(:nodejs)
  end
end
