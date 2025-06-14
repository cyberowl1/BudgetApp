FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq \
  && apt-get install -y build-essential nodejs postgresql-client git yarn

WORKDIR /app

# Clone the repo and checkout main branch
RUN git clone https://github.com/evans22j/Budget-App.git . \
  && git checkout main

# Set up gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application source
COPY . .

# Precompile assets and prepare database
RUN bundle exec rake assets:precompile
RUN bundle exec rake db:create db:migrate

# Expose default Rails port
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
