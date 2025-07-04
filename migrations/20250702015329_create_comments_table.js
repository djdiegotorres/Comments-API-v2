exports.up = function (knex) {
  return knex.schema.createTable('comments', function (table) {
    table.increments('id').primary();
    table.string('email').notNullable();
    table.text('comment').notNullable();
    table.timestamp('created_at').defaultTo(knex.fn.now());
  });
};

exports.down = function (knex) {
  return knex.schema.dropTable('comments');
};