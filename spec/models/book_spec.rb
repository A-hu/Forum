require 'rails_helper'

RSpec.describe Book, type: :model do
	let(:book) { Book.create(name: "123", description: "tttt")}
	let(:user1) { User.create(email: "aaa@aaa.com", password: "1234567")}
	let(:user2) { User.create(email: "bbb@aaa.com", password: "1234567")}
		
 describe ".user_uniq" do
	
  	it "should" do
  		Comment.create(description: "111", user_id: user1.id ,book_id: book.id)
		Comment.create(description: "111", user_id: user1.id ,book_id: book.id)
		Comment.create(description: "111", user_id: user1.id ,book_id: book.id)
		Comment.create(description: "111", user_id: user2.id ,book_id: book.id)

		expect(book.user_uniq).to eq(["aaa" , "bbb"])
  		
  	end
  	it "should" do
  		Comment.create(description: "111", user_id: user1.id ,book_id: book.id)
		Comment.create(description: "111", user_id: user1.id ,book_id: book.id)

		expect(book.user_uniq).to eq(["aaa"])
  		
  	end
  end
end 
