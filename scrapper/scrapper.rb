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

  def crawl(page, filename)
    @links = Set.new
    current_page = get_html "#{page}/?page=#{@current}"
    next_page = current_page.css('.next').length
    loop do
      puts "[+] Crawling : #{page}/?page=#{@current}"
      current_page.css('.f a').each do |a|
        crawled_url = "#{@base_url}#{a[:href]}"
        @links.add  crawled_url unless @links.include? crawled_url
      end
      @current += 1
      current_page = get_html "#{page}/?page=#{@current}"
      break if next_page.zero?

      next_page = current_page.css('.next').length
    end
    File.open(filename, 'w') do |f|
      f.write(@links.to_a.to_json)
    end
    @links
  end

  def movie_info(doc, url, year)
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
    details = {
      name: info[0].to_s.sub(/\s\(.*/, ''),
      year: year.to_s,
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
  data = []
  files = Dir.children('data')
  files.each do |f|
    raw = File.read "./data/#{f}"
    json_data = JSON.parse(raw)
    json_data.each do |a|
      data.append a unless a['name'].nil? && a['name'] != ''
    end
  end
  File.open(outfile, 'w') do |f|
    f.write(data.to_json)
  end
end

base_url = ENV['SITE_URL']
years = (2015..2026).to_a.prepend 2012
# years = [2026]
hydra = Typhoeus::Hydra.new(max_concurrency: 50)

threads = years.map do |year|
  Thread.new do
    page = "#{base_url}/tamil-#{year}-movies"

    crawler = Spider.new base_url, 1
    links = crawler.crawl(page, "urls/#{year}_urls.json")
    links.each do |link|
      req = Typhoeus::Request.new link
      req.on_complete do |res|
        doc = Nokogiri::HTML5(res.response_body)
        crawler.movie_info doc, link, year
      end
      hydra.queue(req)
    end
    hydra.run
    crawler.save_json("data/#{year}.json")
  end
end
threads.each(&:join)
cleanup "../src/data/final.json"
