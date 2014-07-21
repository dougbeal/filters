require "octopress-filters/version"

unless defined? Octopress::Ink
  require "octopress-filters/generator"
end

require "jekyll"
require "rubypants-unicode"
require "titlecase"

module Octopress
  module Filters

    # Escapes HTML content for XML
    def cdata_escape(input)
      input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
    end

    # Returns a title cased string based on John Gruber's title case 
    # Info: http://daringfireball.net/2008/08/title_case_update
    def titlecase(input)
      input.titlecase
    end

    def smartquotes(input)
      RubyPants.new(input).to_html
    end

    # Formats a string for use as a css classname, removing illegal characters
    def classify(input)
      input.gsub(/ /,'-').gsub(/[^\w-]/,'').downcase
    end

    alias_method :sluggify, :classify

    # Remove empty lines
    def compact_newlines(input)
      input.gsub(/\n{2,}/, "\n").gsub(/^ +\n/,"")
    end

    # Join newlines 
    def join_lines(input, separator='')
      compact_newlines(input).strip.gsub(/\s*\n\s*/, separator)
    end

    # Prevent orphans in text by inserting a non-breaking space between the two last words of a string.
    def unorphan(input)
      input.sub(/\s+(\S+)\s*$/, '&nbsp;\1')
    end

    # Prepends input with a url fragment
    #
    # input - An absolute url, e.g. /images/awesome.gif
    # url   - The fragment to prepend the input, e.g. /blog
    #
    # Returns the modified url, e.g /blog
    #
    def expand_url(input, url=nil)
      url ||= root
      if input =~ /^#{url}/
        input
      else
        File.join(url, input)
      end
    end

    # Prepend all absolute urls with a url fragment
    #
    # input - The content of a page or post
    # url   - The fragment to prepend absolute urls
    #
    # Returns input with modified urls
    #
    def expand_urls(input, url=nil)
      url ||= root
      input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\/>]{1}[^\"'>]*)/ do
        $1 + expand_url($3, url)
      end
    end

    # Prepend all urls with the full site url
    #
    # input - The content of a page or post
    #
    # Returns input with all urls expanded to include the full site url
    # e.g. /images/awesome.gif => http://example.com/images/awesome.gif
    #
    def full_urls(input)
      url = Ink.site.config['url']
      if url.nil?
        raise IOError.new "Could not expand urls: Please add your published url to your _config.yml, eg url: http://example.com/"
      else
        expand_urls(input, url)
      end
    end
    
    # Prepend a url with the full site url
    #
    # input - a url
    #
    # Returns input with all urls expanded to include the full site url
    # e.g. /images/awesome.gif => http://example.com/images/awesome.gif
    #
    def full_url(input)
      url = Ink.site.config['url']
      if url.nil?
        raise IOError.new "Could not expand url in #{input}: Please add your site's published url to your _config.yml, eg url: http://example.com/"
      else
        expand_url(input, url)
      end
    end

    module_function *instance_methods
    public *private_instance_methods

    private

    # Returns the site's config root or '/' if the config isn't set
    #
    def root
      root_url = Ink.site.config['root']
      root_url.nil? ? '/' : File.join('/', root_url)
    end
  end
end



Liquid::Template.register_filter Octopress::Filters
