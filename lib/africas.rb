require "africas/version"
require "httparty"

module Africas
  include HTTParty

  attr_accessor :number ,:cost,:status ,:messageId, :base_uri

  base_uri  "http://api.africastalking.com"

  def initialize(number,cost,status,messageId)
    self.number = number
    self.cost = cost
    self.status = status
    self.messageId = messageId
  end

  def self.send(message,to)
    response =  HTTParty.post("/version1/messaging",
                              :headers => {"Apikey" => ENV['AFRICAS_API'],
                                           "Accept" => "application/json"},
                              :body => {:username => ENV['AFRICAS_USER'],
                                        "to" => to,
                                        "message" => message,
                                        "linkId" => SecureRandom.urlsafe_base64})

    if response.success?
      response.each_value do |value|
        value[:Recipients].each do |key1|
          self.new(key1[:number],key1[:cost],key1[:status],key1[:messageId])
        end
      end
    else
      raise response
    end
  end
end
