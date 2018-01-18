require 'spec_helper'

RSpec.describe Liefery do

  it "sets defaults" do
    Liefery::Configurable.keys.each do |key|
      expect(Liefery.instance_variable_get(:"@#{key}")).to eq(Liefery::Default.send(key))
    end
  end

  describe ".client" do
    it "creates an Liefery::Client" do
      expect(Liefery.client).to be_kind_of Liefery::Client
    end

    it "creates new client everytime" do
      expect(Liefery.client).to_not eq(Liefery.client)
    end
  end

  describe ".configure" do
    Liefery::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Liefery.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Liefery.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
