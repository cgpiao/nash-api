## DEPLOY
```shell
#spring stop
rm config/master.key
rm config/credentials.yml.enc
EDITOR="vim" bin/rails credentials:edit
bin/rake db:migrate RAILS_ENV=production
rails s -e production & 
```