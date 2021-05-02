class Relationship < ApplicationRecord
    belongs_to :followers, class_name: "User"
end
