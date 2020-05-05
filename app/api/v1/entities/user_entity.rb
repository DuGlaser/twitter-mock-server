module V1
  module Entities
    class UserEntity < Grape::Entity
      expose :id
      expose :name
      expose :bio
    end
  end
end
