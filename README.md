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

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Version Control

Every time, I was working on a new feature. I add a new branch.
Once I finish coding, I added and committed the change. Checkouted to master and merge it.
Create a new branch and repeat the process.

! [bootstrap] Add boostrap style
! [changestate] changing state between login ad logout
! [deploy] highlight the todo task is overdued
! [homepage] create a landingpage
* [master] make a readme file
! [readme] highlight the todo task is overdued
! [session] add session controller to pass all the tests
! [todos] highlight the todo task is overdued
! [user] init sessions

## Authors

* **Paul Liu** - *Initial work* - [PurpleBooth](https://github.com/paulliu87)
