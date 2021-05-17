require 'faraday'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'json'


def banner()
  puts """
  _____  _______ _______ _     _ _     _
 |     |    |    |_____| |____/  |     |
 |_____|    |    |     | |    \_  |_____|

    TECH OTAKU SAVE THE WORLD
        OtakuDesu Grabber
          Kalls Gryffindorz
  """
end

def cek_online()
  url = "https://otakudesu.moe/"
  cek = Faraday.get(url)
  if cek.status == 200
    puts "[+] Connected to Otakudesu.moe"
    search_anime()
  else
    puts "[+] U are offline "
  end
end


def search_anime()
  print "[?] Judul anime : "
  judul = gets.chomp
  url = "https://otakudesu.moe/?s=#{judul}&post_type=anime"

  nyari = Faraday.get(url)
  grab_body = nyari.body
  parsed_data = Nokogiri::HTML.parse(grab_body)
  links = parsed_data.css("h2 a").each do |grab|
    link_anime = grab['href']

    open_anime(link_anime)
  end
end

def open_anime(linknya)
  open_url = Faraday.get(linknya)
  parsed_data = Nokogiri::HTML.parse(open_url.body)
  title_anime = parsed_data.css("title")
  puts ""
  puts "[?] #{title_anime.text}"
  links_batch = parsed_data.css("li span a").each do |grab|
    ka = grab['href']
    if ka.include? "batch"
      open_batch(ka)
    else
    end
  end
end


def open_batch(linkbatch)
  openlink = Faraday.get(linkbatch)
  parsed_data = Nokogiri::HTML.parse(openlink.body)
  array1 = []
  array2 = []
  grab_title = parsed_data.css("li strong").each do |title|
    array2.append(title.text)
  end
  grab_link = parsed_data.css("a").each do |link|
    if link['href'].include? "otakudrive"
      a= link['href']
      array1.append(a)
    else
    end

  end
  array1.zip(array2).each do |go1, go2|
    short(go1, go2)
  end

end

def short(link, ukuran)
  url = "https://tinyuid.com/api/v1/shorten"
  postkan = Faraday.post(url, "url=#{link}")
  parsed = JSON.parse(postkan.body)
  puts "[!] #{ukuran} => #{parsed["result_url"]}"

end
system("cls")
banner()
cek_online()
