require "rails_helper"

describe "tweets api", :type => :request do
  it "get user tweet" do
    User.create(name: "hogehoge",
                email: "test@bpsinc.jp",
                password: "hogehoge")
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "hogehoge" }
    get "/v1/tweets/1"
    expect(response.status).to eq 200

    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of Array
    expect(body.length).to eq(0)
  end

  it "post tweet" do
    User.create(name: "hogehoge",
                email: "test@bpsinc.jp",
                password: "hogehoge")
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "hogehoge" }

    body = JSON.parse(response.body)
    post "/v1/tweets/#{body["id"]}/create", params: { content: "hoge" }
    expect(response.status).to eq 201

    get "/v1/tweets/#{body["id"]}"
    expect(response.status).to eq 200

    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of Array
    expect(body.length).to eq(1)
  end

  it "delete tweet" do
    User.create(name: "hogehoge",
                email: "test@bpsinc.jp",
                password: "hogehoge")
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "hogehoge" }

    user = JSON.parse(response.body)
    post "/v1/tweets/#{user["id"]}/create", params: { content: "hoge" }
    expect(response.status).to eq 201

    tweet = JSON.parse(response.body)
    delete "/v1/tweets/#{tweet["id"]}/delete"
    expect(response.status).to eq 200

    get "/v1/tweets/#{user["id"]}"
    expect(response.status).to eq 200

    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of Array
    expect(body.length).to eq(0)
  end
end
