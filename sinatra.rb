require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require 'json'

get '/menu' do
    'Hello World'# 점심에는 ?을 먹고 저녁에는 ? 을 드세요
    # 조건: .sample함수는 1번만 사용가능

    menu = ["20층", "순남시래기", "양자강", "한우"]
    lunch = menu.sample
    dinner = menu.shuffle.first

    #puts '점심에는 '+ lunch + '을(를) 먹고 저녁에는 '+ dinner +'을(를) 드세요'

    l1,l2 = menu.sample(2)
    #puts '점심에는 '+ l1 + '을(를) 먹고 저녁에는 '+ l2 +'을(를) 드세요'

    sample = menu.sample(2)
    '점심에는 '+ sample[0] + '을(를) 먹고 저녁에는 '+ sample[1] +'을(를) 드세요'
end

get '/lotto' do
    num = [*1..45].sample(6).sort
    "이번 주 추천 로또 숫자는 "+ num.join(",")+"입니다"
    
end    

get '/check_lotto' do
    
    url = 'http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809'
    lotto = HTTParty.get(url)
    result = JSON.parse(lotto)
    
    numbers = []
    bonus = result["bnusNo"]
    result.each do |k,v|
        if k.include?("drwtNo")
            numbers << v
        end    
    end
    
    numbers.sort
    
    puts "이번 주 번호는"+numbers.join(",")
    puts "보너스 번호는 "+bonus.to_s
    
    my_numbers = [*1..45].sample(6).sort
    puts "내 번호는 "+ my_numbers.join(",")
    
    count = 0
    numbers.each do |num|
        count += 1 if my_numbers.include?(num)
    end 
    
    if count == 6
        puts "1등입니다."
    end
    
    numbers.push(bonus)
   
    count = 0
    numbers.each do |num|
        count += 1 if my_numbers.include?(num)
    end        
    
    
    case count
    when 6
        puts "2등입니다"
    when 5
        puts "3등입니다"
    when 4
        puts "4등입니다"
    when 3
        puts "5등입니다"      
    else
        puts "다음기회에"
    end    
end    

get '/kospi' do

    response = HTTParty.get("http://finance.daum.net/quote/kospi.daum?nil_stock=refresh")
    kospi = Nokogiri::HTML(response)

    result = kospi.css("#hyenCost > b")

    result.text
end
    
get '/html' do
   "<html>
        <head></head>
        <body><h1>Hello World</h1><body>
    </html>" 
end   

get '/html_file' do
    @name = params[:name]
    # send_file 'views/my_first_html.html' 일반적인 파일을 보낼 때 사용하는 
    erb :my_first_html
end 

get '/calculate' do
    num1 = params[:num1]
    num2 = params[:num2]
    
    @add = num1.to_i+ num2.to_i
    @min = num1.to_i- num2.to_i
    @mul = num1.to_i* num2.to_i
    @div = num1.to_i+ num2.to_i
    
    # send_file 'views/my_first_html.html' 일반적인 파일을 보낼 때 사용하는 
    erb :calculate
end 

