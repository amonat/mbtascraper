require 'mechanize'
require 'logger'

agent = Mechanize.new
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

urls = [
  "http://www.mbta.com/schedules_and_maps/bus/routes/?route=CT1",
  #"http://www.mbta.com/schedules_and_maps/bus/routes/?route=CT2",
]

results = []

urls = open('routes.txt').readlines.map {|url| url.strip}

dry_run = ARGV.delete('-n')

for url in urls do
  if dry_run
    puts "dry run: skipping #{url}"
  else
    page = agent.get url
    map = page.at('.icons .pdf:nth-child(1) a').attr('href')
    schedule = page.at('.icons .pdf:nth-child(2) a').attr('href')
    results.push(url: url, map: map, schedule: schedule)
    puts "#{url},#{map},#{schedule}"
    $stdout.flush
    sleep 1.0
  end
end