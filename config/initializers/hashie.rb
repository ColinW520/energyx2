class Response < Hashie::Mash
  disable_warnings
end

Hashie.logger = Logger.new(IO::NULL)
