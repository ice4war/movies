# frozen_string_literal: true

require 'json'
require 'nokogiri'
require 'typhoeus'

class Spider
  def initialize(base_url, current = 1)
    @links = Set.new
    @base_url = base_url
    @current = current
    @movies = Set.new
  end

  def get_html(url)
    html = Typhoeus::Request.new url
    html.run
    Nokogiri::HTML5(html.response.response_body)
  end

  def crawl(page, filename, page_query)
    @links = Set.new
    page_url = "#{page_query}#{@current}"
    current_page = get_html "#{page}#{page_url}"
    next_page = current_page.css('.next').length
    loop do
      puts "[+] Crawling : #{page}#{page_url}"
      current_page.css('.f a').each do |a|
        crawled_url = "#{@base_url}#{a[:href]}"
        @links.add  crawled_url unless @links.include? crawled_url
      end
      @current += 1
      page_url = "#{page_query}#{@current}"
      current_page = get_html "#{page}#{page_url}"
      break if next_page.zero?

      next_page = current_page.css('.next').length
    end
    File.open(filename, 'w') do |f|
      f.write(@links.to_a.to_json)
    end
    @links
  end

  def movie_info(doc, url)
    # doc = get_html url
    img = begin
      doc.css('.movie-info-container picture img')[0][:src]
    rescue StandardError
      ''
    end
    description = begin
      doc.css('.movie-info-container .movie-synopsis')
    rescue StandardError
      ''
    end
    unless description.empty?
      description.css('span').remove
      description = begin
        description[0].content.strip
      rescue StandardError
        ''
      end
    end
    info = []
    doc.css('ul.movie-info li strong').remove
    doc.css('ul.movie-info li').each do |li|
      text = begin
        li.text.strip
      rescue StandardError
        ''
      end
      info.push(text)
    end
    cast = begin
      info[2].split(',')
    rescue StandardError
      ''
    end
    genre = begin
      info[3].split(',')
    rescue StandardError
      ''
    end
    rating = begin
      info[6].split('/')[0]
    rescue StandardError
      ''
    end
    tmp = info[0].to_s.strip
    year = tmp.scan(/\d{4}/)[-1]
    name = tmp.gsub(/\(\d{4}\)/, '').strip
    title = doc.css('title').text
    name = name.empty? ? title.to_s.split('(')[0] : name
    year = year.nil? ? '0000' : year

    details = {
      name: name,
      year: year,
      url: url,
      poster: "#{@base_url}#{img}",
      description: description,
      director: info[1],
      cast: cast,
      genre: genre,
      quality: info[4],
      lang: info[5],
      rating: rating,
      updated: info[7]
    }
    @movies.add details unless @movies.include? details
  end

  def save_json(filename)
    @movies = @movies.to_a
    File.open(filename, 'w') do |f|
      f.write(@movies.to_json)
    end
  end
end

def cleanup(outfile)
  data = Set.new
  files = Dir.children('data')
  files.each do |f|
    raw = File.read "./data/#{f}"
    json_data = JSON.parse(raw)
    json_data.each do |a|
      data.add a unless a['name'].nil? && data.include?(a)
    end
  end
  File.open(outfile, 'w') do |f|
    f.write(data.to_a.to_json)
  end
end

def run_threads(pages, query, base_url, hydra)
  threads = pages.map do |page|
    Thread.new do
      file = "#{base_url.split('/')[-1]}_#{page.split('/')[-1]}"
      crawler = Spider.new base_url, 1
      links = crawler.crawl(page, "urls/#{file}_urls.json", query)
      links.each do |link|
        req = Typhoeus::Request.new link
        req.on_complete do |res|
          doc = Nokogiri::HTML5(res.response_body)
          crawler.movie_info doc, link
        end
        hydra.queue(req)
      end
      hydra.run
      crawler.save_json("data/#{file}.json")
    end
  end
  threads.each(&:join)
end

hydra = Typhoeus::Hydra.new(max_concurrency: 40)
pages = Set.new
sites = ('a'..'z').to_a

## Crawl Site1
base_url = ENV['SITE_URL1']
sites.each do |s|
  pages.add "#{base_url}/tamil-movies/#{s}"
end
pages.add "#{base_url}/tamil-2026-movies"
run_threads(pages, '/?page=', base_url, hydra)

# ## Crawl Site2
base_url = ENV['SITE_URL2']
pages.clear
sites.each do |s|
  pages.add "#{base_url}/tamil-atoz-dubbed-movies/#{s}"
end
run_threads(pages, '/', base_url, hydra)

cleanup '../src/data/final.json'
