module StringFormatter
  refine String do
    def bold
      "\e[1m#{self}\e[0m"
    end

    def underline
      "\e[4m#{self}\e[0m"
    end

    def h1
      "\n#{self}".underline.bold
    end

    def h2
      "\n#{self}".underline
    end

    def red
      "\e[31m#{self}\e[0m"
    end

    def yellow
      "\e[33m#{self}\e[0m"
    end

    def green
      "\e[32m#{self}\e[0m"
    end

    def indented
      "#{self}"
    end
  end
end
