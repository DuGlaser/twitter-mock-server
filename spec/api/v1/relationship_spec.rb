require "rails_helper"

describe "user follow api", :type => :request do
  it "shoud to success following user" do
    User.create(name: "test",
                email: "test@example.com",
                password: "example")
    User.create(name: "test2",
                email: "test2@example.com",
                password: "example")
    post "/v1/users/login", params: { email: "test@example.com",
                                      password: "example" }
    post "/v1/users/login", params: { email: "test2@example.com",
                                      password: "example" }
    get "/v1/users/2/follow"
    expect(response.status).to eq 200

    get "/v1/users/1/following"
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body.length).to eq(1)

    get "/v1/users/2/followers"
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body.length).to eq(1)
  end

  it "shoud to success unfollow user" do
    User.create(name: "test",
                email: "test@example.com",
                password: "example")
    User.create(name: "test2",
                email: "test2@example.com",
                password: "example")
    post "/v1/users/login", params: { email: "test@example.com",
                                      password: "example" }
    get "/v1/users/2/follow"
    expect(response.status).to eq 200

    get "/v1/users/1/following"
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body.length).to eq(1)

    get "/v1/users/2/unfollow"
    expect(response.status).to eq 200
    get "/v1/users/1/following"
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body.length).to eq(0)
  end

  it "should return follower tweet" do
    User.create(name: "test",
                email: "test@example.com",
                password: "example")
    User.create(name: "test2",
                email: "test2@example.com",
                password: "example")
    post "/v1/users/login", params: { email: "test@example.com",
                                      password: "example" }
    body = JSON.parse(response.body)
    puts body
    get "/v1/users/2/follow"
    expect(response.status).to eq 200

    post "/v1/tweets/1/create", params: { content: "test" }

    post "/v1/users/login", params: { email: "test2@example.com",
                                      password: "example" }
    post "/v1/tweets/2/create", params: { content: "test" }
    expect(response.status).to eq 201

    get "/v1/tweets/1/feed"
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body.length).to eq(2)
  end
end
