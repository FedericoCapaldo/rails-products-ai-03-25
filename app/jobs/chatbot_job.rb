class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    @question = question
    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai
      }
    )
    new_content = chatgpt_response["choices"][0]["message"]["content"]
    @question.update(ai_answer: new_content)
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def questions_formatted_for_openai
    results = []
    results << { role: "system", content: "You are an assistant for an e-commerce website." }

    questions = @question.user.questions
    questions.each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end

    return results
  end
end
