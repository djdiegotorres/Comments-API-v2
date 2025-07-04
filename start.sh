#!/bin/sh
npx knex migrate:latest
node index.js