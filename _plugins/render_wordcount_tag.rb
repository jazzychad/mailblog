module Jekyll
  class RenderWordcountBlock < Liquid::Block
    include Liquid::StandardFilters

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end
    
    def render(context)
      super.join.gsub(%r{</?[^>]+?>}, '').split.join(' ').split(' ').length.to_s
    end

  end
end

Liquid::Template.register_tag('wordcount', Jekyll::RenderWordcountBlock)
