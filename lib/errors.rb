module WeTweet
  # raised when empty text are sended to API
  class EmptyTweetError < StandardError
    attr_reader :code

    def initialize
      super
      @code = 400
    end
  end
end
