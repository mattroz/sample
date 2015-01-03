class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
  	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  	has_many :followed_users, through: :relationships, source: :followed

  	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relationships, source: :follower

	before_save { self.email = email.downcase }
	before_create :create_remember_token

	#we shouldnt have blank names with length bigger than 50 symbols
	validates :name, presence: true, length: {maximum: 50}
	
	#regex for validating user email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#we shouldnt have blank email with invalid format and not unique
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, 
			          uniqueness: {case_sensitive: false}
	validates :password, length: { minimum: 6 }

	#user's password will crypt by BCrypt
    has_secure_password

def feed
	# Это предварительное решение. См. полную реализацию в "Following users".
	Micropost.where("user_id = ?", id)
end

def following?(other_user)
  relationships.find_by(followed_id: other_user.id)
end

def follow!(other_user)
  relationships.create!(followed_id: other_user.id)
end

def unfollow!(other_user)
  relationships.find_by(followed_id: other_user.id).destroy!
end

end



# /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	полное регулярное выражение 
# /	начало регулярного выражения
# \A	соответствует началу строки
# [\w+\-.]+	по крайней мере один символ слова, плюс, дефис или точка
# @	буквально “знак собаки”
# [a-z\d\-.]+	по крайней мере одна буква, цифра, дефис или точка
# \.	буквальная точка
# [a-z]+	по крайней мере одна буква
# \z	соответствует концу строки
# /	конец регулярного выражения
# i	нечувствительность к регистру

def User.new_remember_token
  SecureRandom.urlsafe_base64
end

def User.encrypt(token)
  Digest::SHA1.hexdigest(token.to_s)
end

 

private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end


