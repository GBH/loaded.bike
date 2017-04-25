# Loaded.Bike [![Build Status](https://travis-ci.org/GBH/loaded.bike.svg?branch=master)](https://travis-ci.org/GBH/loaded.bike)

Code that powers http://loaded.bike

## Setup

* Clone repo: `clone https://github.com/GBH/loaded.bike.git`
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Inside `/assets` install Node.js dependencies with `npm install`
* Start Phoenix endpoint with `mix phoenix.server`
* Run test suite `mix test`

## Deployment

* `mix edeliver build release`
* `mix edeliver deploy release to production --clean-deploy`
* `mix edeliver migrate production`
* `mix edeliver start production`

---

Copyright 2017, Oleg Khabarov
