require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1m' do
   url = Rails.configuration.x.hook_ops_error
   # result = `systemctl status ipfs`
   # unless result =~ /active \(running\)/
   #    payload = {
   #       text: 'ipfs service is down'
   #    }
   #    HTTP.post url, json: payload
   # end
   # result = `systemctl status delayed-job`
   # unless result =~ /active \(running\)/
   #    payload = {
   #       text: 'delayed-job service is down'
   #    }
   #    HTTP.post url, json: payload
   # end
end