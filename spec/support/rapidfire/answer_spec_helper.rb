module Rapidfire
  module AnswerSpecHelper
    def create_answers
      groups = FactoryGirl.create_list(:answer_group, 3)
      FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi', :answer_group => groups[0])
      FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => "hindi\r\ntelugu", :answer_group => groups[1])
      FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => "hindi\r\nkannada", :answer_group => groups[2])

      FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'mac', :answer_group => groups[0])
      FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'mac', :answer_group => groups[1])
      FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'windows', :answer_group => groups[2])

      FactoryGirl.create(:answer, :question => @question_radio, :answer_text => 'male', :answer_group => groups[0])
      FactoryGirl.create(:answer, :question => @question_radio, :answer_text => 'female', :answer_group => groups[1])

      3.times do |i|
        FactoryGirl.create(:answer, :question => @question_date, :answer_text => Date.today.to_s, :answer_group => groups[i])
        FactoryGirl.create(:answer, :question => @question_long, :answer_text => 'my bio goes on and on!', :answer_group => groups[i])
        FactoryGirl.create(:answer, :question => @question_numeric, :answer_text => 999, :answer_group => groups[i])
        FactoryGirl.create(:answer, :question => @question_short, :answer_text => 'this is cool', :answer_group => groups[i])
      end
    end
  end
end
