module WeTweet
  #  handle malformed requests
  class BadRequestError < StandardError
    attr_reader :code

    def initialize(message = nil)
      super(message)
      @code = 400
    end
  end

  # raised when empty text are sended to API
  class EmptyTweetError < BadRequestError; end
  class MissingParameterError < BadRequestError; end
end
