require 'spec_helper'

describe Rapidfire::QuestionGroupResults do
  include Rapidfire::QuestionSpecHelper
  include Rapidfire::AnswerSpecHelper

  let(:question_group) { FactoryGirl.create(:question_group) }

  before do
    create_questions(question_group)
    create_answers
    @question_group_results =
      Rapidfire::QuestionGroupResults.new(question_group: question_group)
  end

  describe '#extract' do
    before do
      @results = @question_group_results.extract
    end

    it 'returns checkbox answers as a hash containing options as keys and number of answers as values' do
      answers = @results.find { |result| result.question == @question_checkbox }
      expect(answers.results['hindi']).to eq(3)
      expect(answers.results['telugu']).to eq(1)
      expect(answers.results['kannada']).to eq(1)
    end

    it 'returns "date" type answers as an array' do
      answers = @results.find { |result| result.question == @question_date }
      expect(answers.results).to be_a(Array)
    end

    it 'returns "long" type answers as an array' do
      answers = @results.find { |result| result.question == @question_long }
      expect(answers.results).to be_a(Array)
    end

    it 'returns "numeric" type answers as an array' do
      answers = @results.find { |result| result.question == @question_numeric }
      expect(answers.results).to be_a(Array)
    end

    it 'returns "short" type answers as an array' do
      answers = @results.find { |result| result.question == @question_short }
      expect(answers.results).to be_a(Array)
    end

    it 'returns "radio" type answers as a hash containing options as keys and number of answers as values' do
      answers = @results.find { |result| result.question == @question_radio }
      expect(answers.results['male']).to eq(1)
      expect(answers.results['female']).to eq(1)
    end

    it 'returns "select" type answers as a hash containing options as keys and number of answers as values' do
      answers = @results.find { |result| result.question == @question_select }
      expect(answers.results['mac']).to eq(2)
      expect(answers.results['windows']).to eq(1)
    end

    it 'returns "short" type answers as an array' do
      answers = @results.find { |result| result.question == @question_short }
      expect(answers.results).to be_a(Array)
    end
  end

  describe '#extrect_filtered' do
    before do
      @results = @question_group_results.extract(filter)
    end

    context 'filtered by one param' do
      let(:filter) { {@question_select.id => 'mac'} }

      it 'returns filtered checkbox answers as a hash containing options as keys and number of answers as values' do
        answers = @results.find { |result| result.question == @question_checkbox }
        expect(answers.results['hindi']).to eq(2)
        expect(answers.results['telugu']).to eq(1)
      end
    end

    context 'filtered by checkbox one param' do
      let(:filter) { {@question_checkbox.id => 'kannada'} }

      it 'returns filtered checkbox answers as a hash containing options as keys and number of answers as values' do
        answers = @results.find { |result| result.question == @question_checkbox }
        expect(answers.results['hindi']).to eq(1)
        expect(answers.results['kannada']).to eq(1)
      end
    end

    context 'filtered by more params' do
      let(:filter) { {@question_select.id => 'mac', @question_radio.id => 'female'} }

      it 'returns filtered checkbox answers as a hash containing options as keys and number of answers as values' do
        answers = @results.find { |result| result.question == @question_checkbox }
        expect(answers.results['hindi']).to eq(1)
        expect(answers.results['telugu']).to eq(1)
      end
    end

    context 'filtered with no match' do
      let(:filter) { {@question_select.id => 'mac', @question_radio.id => 'female', @question_checkbox.id => 'kannada'} }

      it 'returns filtered checkbox answers as a hash containing options as keys and number of answers as values' do
        answers = @results.find { |result| result.question == @question_checkbox }
        expect(answers.results).to eq({})
      end
    end
  end

end
