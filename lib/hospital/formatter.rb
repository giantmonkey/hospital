module Formatter
  refine String do
    def h1
      "\n\e[4m\e[1m#{self}\e[0m"
    end

    def h2
      "\n\e[4m#{self}\e[0m"
    end

    def red
      "\e[31m#{self}\e[0m"
    end

    def yellow
      "\e[33m#{self}\e[0m"
    end
  end
end
