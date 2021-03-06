# TODOs

A Web App To-Do List.
The project goals are:
* As a user, I can add a TODO to the list.
* As a user, I can see all the TODOs on the list in an overview.
* As a user, I can drill into a TODO to see more information about the TODO.
* As a user, I can delete a TODO.
* As a user, I can mark a TODO as completed.
* As a user, when I see all the TODOs in the overview, if today's date is past the TODO's deadline, highlight it.

## Getting Started

* Followed the MVC design pattern hardly to perform a solid design process.
* Used TDD for development.

First I am looking at the scenario. The first step: Enumerate. I listed all possible features:
* Add todo
* Display todos
* View certain todo
* Delete todo
* Mark a todo as completed
* Hight light the passed todo task
* Search a todo
* Show todos based on their deadline
* Show unfinished todos in separate column
* User can login/register
* Coming up todos

Now, second steps: Sort. I want to make the MVP, so I need to make sure it has all the required feature before I add more to it.

* User can login/register
* Add todo
* Display todos
* View certain todo
* Delete todo
* Mark a todo as completed
* Hight light the passed todo task

Time to do some drawing, I made some mockups for myself to better assess the visual hierarchy between elements.

Next step: Analysis & Predict

I need to consider the QPS.The The reasons QPS plays a big role are below:
* QPS decides that type web server
* QPS decides the relationship between web server and database

For this practice, I assumed the QPS is under 100. A laptop will handle it all. Since I planned to deploy my project to heroku, I would use a web server. And a web server can handle 1k QPS.

Since I am really not going use all 1k QPS, a SQL database would be ideal, I chose PostgreSQL.

Next step: service. In this case, all I need is the sorted features.

Now, I looked at storage.

I started with todos since it contains most of the features. And I also need users.

Now it looks like this:

User Service ===> SQL
Todo Service ===> SQL

Next step: schema.

User service:
* username
* password
* password_confirmation

Todo service:
* title
* deadline
* completed
* detail
* overdued

I added a session service to help existed user to login.

Now user story:

User == 1. login/register ==> Web Server == 2. Get user information ==> User table
User Table == 3 send the information back ==> Web server == 4. get todos ==> Todo table
Todo table == 5. feed back todo list ==> Web Server == 6. Display ==> User

Since I have the user story layout, I start to write tests to controller, model and view.

Once I have my expectation setup, I can start code the really controller, model and view to pass all the tests.

I made sure all tests passed.

Last step: deploy.

## Time Management

Since I expect to make this project under 10 hours, I decided to time box my tasks:

Design, setup Trello board and development environment: 1hr
User login, register and logout: 2hr
Display todos: 1hr
View todo: 1hr
Add todo: 1hr
Delete todo: 1hr
Mark as completed: 1hr
High Light: 1hr
Styling: 1hr
Edit README: 1hr

I used Trello Board to keep my task on track.

### Prerequisites

* Ruby on Rails
* PostgreSQL
* Homebrew
* rbenv

Installing Homebrew, simply open Terminal and run the following command

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Installing rbenv, which is the ruby version management tool. Follow closely with the installation instruction from:

https://github.com/rbenv/rbenv


Installing Ruby on Rails, choose the version of ruby you want to install. (2.4.0 recommended). To do this, run the following commands in your Terminal:

```
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile

# Install Ruby
rbenv install 2.4.0
rbenv global 2.4.0
ruby -v
```

Installing Rails (5.1.1 Recommend)

Installing Rails is as simple as running the following command in your Terminal:

```
gem install rails -v 5.1.1
```

Rails is now installed, but in order for us to use the rails executable, we need to tell rbenv to see it:

```
rbenv rehash
```

And now we can verify Rails is installed:

```
rails -v
# Rails 5.1.1
```

Now, setup PostgreSQL

Run this command in the terminal:

```
brew install postgresql
```

Once this command is finished, it gives you a couple commands to run. Follow the instructions and run them:

```
# To have launchd start postgresql at login:
ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents

# Then to load postgresql now:
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

### Gems


* Use postgresql as the database for Active Record
* Use bycrypt has_secure_password
* Use RSpec and Capybara to do the testing


### Installing

For online access to the web app, please visit https://thawing-chamber-42985.herokuapp.com/

To run this app on your local machine, navigate to your repository folder and run the following cmd in terminal

```
git clone https://github.com/paulliu87/todos.git
```
Once the project is downloaded, run the cmd to access the folder

```
cd todos
```

Install gems

```
bundle install
```

Make sure the PostgreSQL is running, simply run

```
ps auxwww | grep postgres
```

If something like

```
/Library/PostgreSQL/8.3/bin/postgres -D /Library/PostgreSQL/8.3/data

```

The PostgreSQL is running properly, otherwise run the following cmd to restart the PostgreSQL.

```
brew services restart postgresql
```

Migrate the database

```
bundle exec rake db:migrate
```

Start the server

```
rails server
```

Now, you can open a chrome and enter localhost:3000 to use the web app

To deploy this project to heroku, make sure you have a heroku account.

## Running the tests

There are over 30 RSpec tests for controller, model, and view.

To run all the tests on the terminal, run the cmd below

```
bundle exec rspec spec
```
To run the tests for specific controller or for specific unit method, follow the pattern as follow:

```
bundle exec rspec spec/controllers/users_controller_spec.rb

bundle exec rspec spec/controllers/users_controller_spec.rb:50
```

## Deployment

https://thawing-chamber-42985.herokuapp.com/

I deployed this project to heroku since it is free.

Simply run

```
heroku create
```

Migrate pg db

```
heroku run rake db:migrate
```
Open the app

```
heroku open
```

## Support Documents

* [Rails Doc.](http://guides.rubyonrails.org/getting_started.html) - Ruby on Rails
* [Stack Overflow](https://stackoverflow.com/) - Very Helpful answers
* [Relish](https://relishapp.com/rspec) - RSpec Relish
* [Heroku](https://devcenter.heroku.com/articles/git) - Heroku deployment
* [Trello](https://trello.com/b/nXlFFEu0/todo-list) - Project Management Tool


## Version Control

Every time, I was working on a new feature, I add a new branch.
Once I finish coding, I added and committed the change. Checkouted to master and merge it.
Create a new branch and repeat the process.

* ! [bootstrap] Add boostrap style
* ! [changestate] changing state between login ad logout
* ! [deploy] highlight the todo task is overdued
* ! [homepage] create a landingpage
* * [master] make a readme file
* ! [readme] highlight the todo task is overdued
* ! [session] add session controller to pass all the tests
* ! [todos] highlight the todo task is overdued
* ! [user] init sessions

## Authors

* **Paul Liu** - *Initial work* - [todos](https://github.com/paulliu87/todos)
