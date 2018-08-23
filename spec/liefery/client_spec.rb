require 'spec_helper'
require 'json'

RSpec.describe Liefery::Client do
  describe "module configurable" do
    before do
      Liefery.configure do |config|
        Liefery::Configurable.keys.each do |key|
          config.send("#{key}=", "the #{key} value")
        end
      end
    end

    it "inherits the module configuration" do
      client = Liefery::Client.new

      Liefery::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("the #{key} value")
      end
    end

    describe "with class level configuration" do
      it "overrides module configuration" do
        options = { api_key: "the_api_key" }
        client = Liefery::Client.new(options)

        expect(client.api_key).to eq("the_api_key")
        expect(client.user_agent).to eq(Liefery.user_agent)
      end

      it "can set configuration after initialization" do
        options = { api_key: "the_api_key" }
        client = Liefery::Client.new
        client.configure do |config|
          options.each do |key, value|
            config.send("#{key}=", value)
          end
        end

        expect(client.api_key).to eq("the_api_key")
        expect(client.user_agent).to eq(Liefery.user_agent)
      end
    end
  end

  describe ".get" do
    it "requests the given resource using get" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_get("/something?foo=bar")

      client.get "something", foo: "bar"

      expect(request).to have_been_made
    end

    it "passes along request headers" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_get("/").
        with(query: { foo: "bar" }, headers: { accept: "text/plain" })
      client.get "", foo: "bar", accept: "text/plain"

      expect(request).to have_been_made
    end
  end

  describe ".head" do
    it "requests the given resource using head" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_head("/something?foo=bar")

      client.head "something", foo: "bar"

      expect(request).to have_been_made
    end

    it "passes along request headers" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_head("/").
        with(query: { foo: "bar" }, headers: { accept: "text/plain" })

      client.head "", foo: "bar", accept: "text/plain"

      expect(request).to have_been_made
    end
  end

  describe ".post" do
    it "requests the given resource using post" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_post("/something").
        with(body: { foo: "bar" }.to_json)

      client.post "something", foo: "bar"

      expect(request).to have_been_made
    end

    it "passes along request headers" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      headers = { "X-Foo" => "bar" }
      request = stub_post("/").
        with(body: { foo: "bar" }.to_json, headers: headers)

      client.post "", foo: "bar", headers: headers

      expect(request).to have_been_made
    end
  end

  describe ".put" do
    it "requests the given resource using put" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_put("/something").
        with(body: { foo: "bar" }.to_json)

      client.put "something", foo: "bar"

      expect(request).to have_been_made
    end

    it "passes along request headers" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      headers = { "X-Foo" => "bar" }
      request = stub_put("/").
        with(body: { foo: "bar" }.to_json, headers: headers)

      client.put "", foo: "bar", headers: headers

      expect(request).to have_been_made
    end
  end

  describe ".patch" do
    it "requests the given resource using patch" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_patch("/something").
        with(body: { foo: "bar" }.to_json)

      client.patch "something", foo: "bar"

      expect(request).to have_been_made
    end

    it "passes along request headers" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      headers = { "X-Foo" => "bar" }
      request = stub_patch("/").
        with(body: { foo: "bar" }.to_json, headers: headers)

      client.patch "", foo: "bar", headers: headers

      expect(request).to have_been_made
    end
  end

  describe ".delete" do
    it "requests the given resource using delete" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_delete("/something")

      client.delete "something"

      expect(request).to have_been_made
    end

    it "passes along request headers" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      headers = { "X-Foo" => "bar" }
      request = stub_delete("/").with(headers: headers)

      client.delete "", headers: headers

      expect(request).to have_been_made
    end
  end

  describe "when making requests" do

    it 'uses the sandbox endpoint by default' do
      client = Liefery::Client.new

      expect(client.api_endpoint).to eq 'https://staging.liefery.com/'
    end

    it "uses the production endpoint when production is set to true" do
      client = Liefery::Client.new(production: true)

      expect(client.api_endpoint).to eq 'https://www.liefery.com/'
    end

    it "sets a default user agent" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      request = stub_get("/").
        with(headers: { user_agent: Liefery::Default.user_agent })

      client.get ""

      expect(request).to have_been_made
    end

    it "accepts a custom user agent" do
      user_agent = "Mozilla/1.0 (Win3.1)"
      client = Liefery::Client.new(user_agent: user_agent)
      request = stub_get("/").with(headers: { user_agent: user_agent })

      client.get ""

      expect(request).to have_been_made
    end

    it 'creates the correct auth headers' do
      api_key = 'the_api_key'
      request = stub_get('/').with(headers: { 'API-Key' => api_key })
      client = Liefery::Client.new(api_key: api_key)

      client.get ""

      expect(request).to have_been_made
    end
  end

  context "error handling" do
    it "raises on 404" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      stub_get('/four_oh_four').to_return(status: 404)

      expect { client.get('four_oh_four') }.to raise_error Liefery::NotFound
    end

    it "raises on 500" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      stub_get('/five_oh_oh').to_return(status: 500)

      expect { client.get('five_oh_oh') }.to raise_error Liefery::InternalServerError
    end

    it "raises a ClientError on unknown client errors" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      stub_get('/something').to_return(
        status: 418,
        headers: { content_type: "application/json" },
        body: fixture('create_shipment_error.json')
      )

      expect { client.get('something') }.to raise_error Liefery::ClientError
    end

    it "raises a ServerError on unknown server errors" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      stub_get('/something').to_return(
        status: 509,
        headers: { content_type: "application/json" },
        body: fixture('create_shipment_error.json')
      )

      expect { client.get('something') }.to raise_error Liefery::ServerError
    end

    it "returns an error object" do
      client = Liefery::Client.new(api_key: '5cca5039c7b44aacb1')
      stub_get('/something').to_return(
        status: 422,
        headers: { content_type: "application/json" },
        body: fixture('create_shipment_error.json')
      )

      expect { client.get('something') }.to raise_error(
        Liefery::UnprocessableEntity,
        'Packages package size can\'t be blank, ' \
          'Packstücke not created, Status -> Price can not be calculated, ' \
          'Beginn Ablieferzeit ist nicht möglich, da zu zeitnah'
      )
    end
  end

  describe '.sandbox_api_endpoint' do
    it 'returns url of the sandbox endpoint' do
      client = Liefery::Client.new

      expect(client.sandbox_api_endpoint).to eq 'https://staging.liefery.com'
    end
  end

  describe '.production_api_endpoint' do
    it 'returns url of the sandbox endpoint' do
      client = Liefery::Client.new

      expect(client.production_api_endpoint).to eq 'https://www.liefery.com'
    end
  end
end
