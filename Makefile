.PHONY: build
build:
	[ -f .env ] || cp .env.docker.sample .env
	docker-compose build

.PHONY: run
run:
	docker-compose run --rm --service-ports --use-aliases web

.PHONY: reset-db
reset-db: recreate-db migrate-db fixtures

.PHONY: recreate-db
recreate-db:
	bundle exec rails db:drop db:create

.PHONY: migrate-db
migrate-db:
	bundle exec dotenv -f ".env" ridgepole --config ./config/database.yml --file ./db/Schemafile --apply
	bundle exec dotenv -f ".env" ridgepole --config ./config/database.yml --file ./db/Schemafile --apply -E test

.PHONY: fixtures
fixtures:
	wget https://iich-develop.s3-ap-northeast-1.amazonaws.com/fixtures_data.zip
	unzip fixtures_data.zip -d public
	bundle exec rails db:fixtures:load
	bundle exec rails db:fixtures:load RAILS_ENV=test
	bundle exec rake encode:all

.PHONY: lint
lint:
	bundle exec rubocop --auto-correct
	bundle exec slim-lint app/
	yarn lint

.PHONY: console
console:
	bundle exec rails c

.PHONY: rspec
rspec:
	bundle exec rspec

.PHONY: routes
routes:
	bundle exec rails routes

.PHONY: annotate
annotate:
	bundle exec annotate

.PHONY: timory
timory:
	heroku run rails c

.PHONY: timory_reset_db
timory_reset_db:
	heroku pg:reset DATABASE_URL

.PHONY: timory_mail
timory_mail:
	heroku run rails c
	ActionMailer::Base.mail(
	from: 'iken.ishikawa@gmail.com', 
	to: "iken.ishikawa@gmail.com", 
	subject: "テストメール", 
	body: "これはテストです。"
	).deliver_now

