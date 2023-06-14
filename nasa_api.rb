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

def photos_count(json_hash)
    count = Hash.new(0)
    json_hash['photos'].each do |photo|
        camera_name = photo['camera']['name']
        count[camera_name] += 1
    end
    return count
end

def build_web_page(json_hash)
    images = json_hash['photos'].map { |photo| photo['img_src'] }

    # Start of HTML
    html = "<!DOCTYPE html>\n<html lang='en'>\n<head>\n    <meta charset='UTF-8'>\n    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n    <link rel='stylesheet' href='assets/css/style.css'>\n    <title>Desafío evaluado APIs</title>\n</head>\n<body>\n<ul>\n"

    # End of HTML document
    html_close_tags = "</body>\n</html>"

    # Adding images
    images.each_with_index { |img, i| html += "    <li>Image #{i+1}<img src=#{img}></li>\n" }

    # Adding camera photo count
    html += "</ul>\n<p>Camera photo count:</p>\n"
    camera_photo_count = photos_count(json_hash)
    camera_photo_count.each { |camera, count| html += "<p>#{camera}: #{count}</p>\n" }

    # Finishing HTML and write out to file
    html.concat(html_close_tags)
    File.write('index.html', html)
end

# Default query (by Martian sol)
default_query = {
    sol: 0,
    camera: '',
    page: 1
}

# Custom query
# Change these values to change the query
query = {
    sol: 10,
    camera: '',
    page: 1
}

# Base query URL
query_url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?"

# Add parameters to query
query.each do |parameter, value|
    query_url += "#{parameter}=#{value}&" if value != default_query[parameter]
end

# Add API key to query
api_key = 'W18wj4kULGEQmbvddFWqanfW7pprXnq2AeAqQyrg'
query_url += "api_key=#{api_key}"

# API request
nasa_photos = request(query_url)

# Code for testing with local json file (sol = 10)
# local_json = File.read('assets/json/local_json.json')
# nasa_photos = JSON.parse(local_json)

# Build webpage with data from API
build_web_page(nasa_photos)
