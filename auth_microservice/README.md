# Auth Microservice (on RabbitMQ)
Auth microservice for [Ads Microservice](https://github.com/rubygitflow/ads_microservice/tree/logging) on RabbitMQ from Ruby Microservices course

## Download this app from the repository
It's set up so you can clone this repository and base your application on it:
```bash
$ git clone git@github.com:rubygitflow/auth_microservice.git app_auth --single-branch --branch logging && cd app_auth && rm -r -f .git/
```
Initialize and configure a new Git repository (you need to have a [personal access token](https://github.com/settings/tokens)):
```bash
$ git init
$ git config --global user.name # get USER_NAME from your own Git repository
$ git config --global user.name USER_NAME # set USER_NAME from your own Git repository if the "global user.name" is empty
$ git config --global user.email USER_EMAIL # set USER_EMAIL from your own Git repository if the "global user.name" is empty
# create the new repository
$ curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>" \
  https://api.github.com/user/repos \
  -d'{"name":"app_auth", "description":"Some information"}'
$ git remote add origin git@github.com:USER_NAME/app_auth.git 
$ git add . && git commit -m 'init project'
$ git push -u origin master
```
For more details, see the [github docs](https://docs.github.com/en/rest/repos/repos#create-a-repository-for-the-authenticated-user)

## Database Setup
By default Sequel assumes a PostgreSQL database, with an application specific PostgreSQL database account.  You can create this via:
```bash
$ createuser -U postgres app_auth
$ createdb -U postgres -O app_auth auth_microservice_production -p 5432 -h 127.0.0.1
$ createdb -U postgres -O app_auth auth_microservice_test -p 5432 -h 127.0.0.1
$ createdb -U postgres -O app_auth auth_microservice_development -p 5432 -h 127.0.0.1
```
Create password for user account via:
```bash
$ sudo su - postgres
$ psql -c "alter user app_auth with password 'mypassword'"
```
Configure the database connection defined in .env.rb for the ENV parameter `ENV['AUTH_MICROSERVICE_DATABASE_URL'] ||= "postgres://user:password@host:port/database_name_environment"` like so:
```ruby
case ENV['RACK_ENV'] ||= 'development'
when 'test'
  ENV['AUTH_MICROSERVICE_DATABASE_URL'] ||= "postgres://app_auth:mypassword@127.0.0.1:5432/auth_microservice_test"
when 'production'
  ENV['AUTH_MICROSERVICE_DATABASE_URL'] ||= "postgres://app_auth:mypassword@127.0.0.1:5432/auth_microservice_production"
else
  ENV['AUTH_MICROSERVICE_DATABASE_URL'] ||= "postgres://app_auth:mypassword@127.0.0.1:5432/auth_microservice_development"
end
```
According to the [Sequel documentation](https://github.com/jeremyevans/sequel#connecting-to-a-database-), you can also specify optional parameters `Settings.db` in `config/settings/*.yml` and `config/*.yml`

## Environment setup
```bash
$ bundle install
```
## Run App
Either set up configuration into `config/initializers/config.rb`, `config/settings/*.yml` and `config/*.yml` before running

```bash
$ bin/puma
$ bin/console
```
or run the application with modified configuration using environment variables
```bash
$ ENV__PAGINATION__PAGE_SIZE=100 LOG_SERVICE=stdout bin/puma
$ RACK_ENV=test bin/console
```
## HTTP-requests to the app
```bash
$ curl --url "http://localhost:3000" -v
$ http :3000
$ http -f post ":3000/api/v1/user" "name=bob" "email=bob@example.com" "password=password"
$ http -f post ":3000/api/v1/user_session" "email=bob@example.com" "password=password"
$ http -f post ":3000/api/v1/auth" "Authorization:Bearer some_token_received_in_user_session"
```
## Run tests
```bash
$ bin/rspec
```
## Additional tips
1. Use a timestamp for the new migration filename:
```bash
$ date -u +%Y%m%d%H%M%S
```
2. After adding additional migration files, you can run the migrations:
```bash
$ rake dev_up  
$ rake test_up 
$ rake prod_up 
```
3. After modifying the migration file, you can drop down and then back up the migrations with a single command:
```bash
$ rake dev_bounce  
$ rake test_bounce 
```
4. Roll back database migration all the way down:
```bash
$ rake dev_down  
$ rake test_down 
$ rake prod_down 
```
5. Feed the database with initial data:
```bash
$ rake dev_seed
$ rake test_seed
$ rake prod_seed
```
6. The list of all tasks is called by the command:
```bash
$ bin/rake --tasks
```
7. Making a database's schema dump and [other manipulations](https://sequel.jeremyevans.net/rdoc/files/doc/bin_sequel_rdoc.html) from the command line interface
```bash
$ bin/sequel -d postgres://user:pass@host/database_name
$ bin/sequel -D postgres://user:pass@host/database_name
```

## Author
* it.Architect https://github.com/rubygitflow
* Inspired by [Jeremy Evans](https://github.com/jeremyevans/roda-sequel-stack) and [Evgeniy Fateev](https://github.com/psylone/auth-microservice)
