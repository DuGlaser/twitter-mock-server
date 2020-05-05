require "rails_helper"

describe "users api", :type => :request do
  it "should return user array" do
    User.create(name: "hoge", email: "hoge@examle.com", password: "example")
    User.create(name: "piyo", email: "piyo@examle.com", password: "example")
    User.create(name: "fuga", email: "fuga@examle.com", password: "example")

    get "/v1/users"
    expect(response.status).to eq 200

    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of Array
    expect(body.length).to eq(3)
  end

  it "should to create user" do
    post "/v1/users/signup", params: { email: "test@bpsinc.jp",
                                       password: "hogehoge",
                                       name: "hogehoge" }

    expect(response.status).to eq 201
    get "/v1/users"
    expect(response.status).to eq 200

    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of Array
    expect(body.length).to eq(1)
  end

  it "should to success login" do
    post "/v1/users/signup", params: { email: "test@bpsinc.jp",
                                       password: "hogehoge",
                                       name: "hogehoge" }
    expect(response.status).to eq 201
    expect(cookies[:user_id]).to eq nil
    expect(cookies[:remember_token]).to eq nil
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "hogehoge" }
    expect(response.status).to eq 201

    expect(cookies[:user_id]).not_to eq nil
    expect(cookies[:remember_token]).not_to eq nil
  end

  it "should to failed login" do
    User.create(name: "hogehoge",
                email: "test@bpsinc.jp",
                password: "hogehoge")
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "aaaaaaaa" }
    expect(response.status).to eq 401
  end

  it "should to delete user" do
    User.create(name: "hogehoge",
                email: "test@bpsinc.jp",
                password: "hogehoge")
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "hogehoge" }
    body = JSON.parse(response.body)
    delete "/v1/users/#{body["id"]}"
    expect(response.status).to eq 200
  end

  it "should to update user column" do
    User.create(name: "hogehoge",
                email: "test@bpsinc.jp",
                password: "hogehoge")
    post "/v1/users/login", params: { email: "test@bpsinc.jp",
                                      password: "hogehoge" }
    body = JSON.parse(response.body)
    patch "/v1/users/#{body["id"]}", params: { bio: "test bio",
                                               name: "hugahuga" }
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body["bio"]).to eq("test bio")
    expect(body["name"]).to eq("hugahuga")
  end
end
