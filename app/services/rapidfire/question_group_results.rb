module Rapidfire
  class QuestionGroupResults < Rapidfire::BaseService
    attr_accessor :question_group

    # extracts question along with results
    # each entry will have the following:
    # 1. question type and question id
    # 2. question text
    # 3. if aggregatable, return each option with value
    # 4. else return an array of all the answers given
    def extract(filter = nil)
      groups = filter ? get_groups(filter) : nil

      @question_group.questions.collect do |question|
        results =
          case question
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            question_results = answers(question, groups).map(&:answer_text).map do |text|
              text.to_s.split(Rapidfire.answers_delimiter)
            end.flatten

            question_results.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric
            answers(question, groups).pluck(:answer_text)
          end

        QuestionResult.new(question: question, results: results)
      end
    end

    def get_groups(filter)
      groups = @question_group.questions.find(filter.keys).map do |question|
        question.answers.select do |a|
          if question.class == Rapidfire::Questions::Checkbox
            a.answer_text.split(Rapidfire.answers_delimiter).include?(filter[question.id])
          else
            a.answer_text == filter[question.id]
          end
        end.map(&:answer_group_id)
      end

      groups.inject(:'&')
    end

    private

    def answers(question, groups = nil)
      return question.answers if groups.nil?

      question.answers.where(answer_group_id: groups)
    end
  end
end
