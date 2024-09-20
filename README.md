# Little Shop | Final Project | Backend Starter Repo

This repository is the completed API for use with the Mod 2 Group Project. The FE repo for Little Shop lives [here](https://github.com/turingschool-examples/little-shop-fe-vite).

This repo can be used as the starter repo for the Mod 2 final project.

## Setup

```ruby
bundle install
rails db:{drop,create,migrate,seed}
rails db:schema:dump
```

```
rails db:{drop,create}
rails runner ActiveRecord::Tasks::DatabaseTasks.load_seed
rails db:migrate
```


This repo uses a pgdump file to seed the database. Your `db:seed` command will produce lots of output, and that's normal. If all your tests fail after running `db:seed`, you probably forgot to run `rails db:schema:dump`. 

Run your server with `rails s` and you should be able to access endpoints via localhost:3000.
