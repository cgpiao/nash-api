## DEPLOY
```shell
#spring stop
rm config/master.key
rm config/credentials.yml.enc
EDITOR="vim" bin/rails credentials:edit
bin/rake db:migrate RAILS_ENV=production

RAILS_ENV=production bin/delayed_job start
rails s -e production & 
```
```sql
create database nash_test;
CREATE ROLE nash_test_user WITH LOGIN SUPERUSER PASSWORD 'qwer1234';
create user xxx_user with encrypted password 'qwer1234';
grant all on database nash_test to nash_user_test;
```