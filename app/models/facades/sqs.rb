require 'aws-sdk'

module Facades
  class SQS

    attr_accessor :queue

    def initialize(queue_name)
      return if Rails.env.test?

      AWS.config({
      :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"],
      :region => "eu-west-1"
      })

      sqs = AWS::SQS.new 

      @queue = begin
                sqs.queues.named(queue_name)
              rescue AWS::SQS::Errors::NonExistentQueue => e
                sqs.queues.create(queue_name,
                  :visibility_timeout => 90,
                  :message_retention_period => 1209600)
              end
    end

    def send(message)
      @queue.send_message("#{message}")
    end

    def poll
      puts "Start polling queue : #{@queue.url}"
      @queue.poll do |received_message| 
        yield(received_message.body)
        received_message.delete
      end
    end
  end
end