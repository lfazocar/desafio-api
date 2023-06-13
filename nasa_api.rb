require "uri"
require "net/http"
require 'json'

def request(url_request)

    url = URI(url_request)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    return JSON.parse(response.body)

end

def build_web_page(json_hash)
    images = json_hash['photos'].map { |photo| photo['img_src'] }
    html = "<!DOCTYPE html><html lang='en'><head>\n    <meta charset='UTF-8'>\n    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n    <title>Desafío evaluado APIs</title>\n</head>\n<body>\n<ul>\n"
    html_close_tags = "</ul>\n</body>\n</html>"
    images.each { |img| html += "    <li><img src=#{img}></li>\n" }
    html.concat(html_close_tags)
    File.write('index.html', html)
end

def photos_count(json_hash)
    count = Hash.new(0)
    json_hash['photos'].each do |photo|
        camera_name = photo['camera']['name']
        count[camera_name] += 1
    end
    return count
end

local_json = File.read('assets/json/local_json.json')
nasa_photos = JSON.parse(local_json)

#api_key = ''
#nasa_photos = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=#{api_key}")

puts photos_count(nasa_photos)
build_web_page(nasa_photos)
