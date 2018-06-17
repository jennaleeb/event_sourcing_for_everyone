module Commands
  class BaseCommand
    def initialize(args = {})
      @args = args
      validate!
    end

    def validate!
      raise NotImplementedError, 'Derived classes must implement #validate!'
    end
  end
end
