include Jekyll::Filters

module Jekyll

  # Sub-class Jekyll::StaticFile to allow recovery from an unimportant exception when writing files.
  class StaticTagsFile < StaticFile
    def write(dest)
      super(dest) rescue ArgumentError
      true
    end
  end


  class Site
    def write_tags_page
      tags_filename = "tags.html"

      str = generate_tags(self)


      File.open(File.join(self.source, tags_filename), 'w') do |f|
        f.truncate(0)
        f.write(str) 
      end

      tags = Jekyll::Page.new(self, self.source, '', tags_filename)
      tags.render(self.layouts, site_payload)
      tags.write(self.dest)
      self.pages << tags
      self.static_files << Jekyll::StaticTagsFile.new(self, self.dest, '/', tags_filename)

      File.delete(File.join(self.source, tags_filename)) rescue NameError


    end

    private

    def generate_tags(site)

      html =<<-HTML
---
layout: default
title: Tags
---
<a name="top"></a>
<h1>Tags</h1>

    HTML
      
      site.tags.sort.each do |tag, posts|
        html << <<-HTML
        <a href="##{tag}">#{tag}</a><br/>
      HTML
      end
      
      html << '<hr style="color:#ddd;border:0px;border-bottom: 1px solid #ddd; height:1px;"/>'
      
      site.tags.sort.each do |tag, posts|
        len = posts.length
        html << <<-HTML
      <a name="{tag}"></a>
      <h2 id="#{tag}">#{tag}[#{len}]</h2>
      HTML
        
        html << '<ul class="posts">'
        posts.each do |post|
          post_data = post.to_liquid
          html << <<-HTML
          <li>
            <span class="tagdate">#{ date_to_long_string post.date }</span> &ndash; 
            <a href="#{post.url}">#{post_data['title']}</a>
          </li>
        HTML
        end
        html << '<li style="margin-top:8px;"><a href="#top">Back to Top</a></li>'
        html << '</ul>'
      end
      
      html
    end
    
  end




  class TagsGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      
      site.write_tags_page

    end

  end
end
