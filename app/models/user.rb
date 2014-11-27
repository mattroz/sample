class User < ActiveRecord::Base
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, 
			          uniqueness: {case_sensitive: false}
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
