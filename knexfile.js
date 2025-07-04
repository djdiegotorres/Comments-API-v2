module.exports = {
  development: {
    client: 'sqlite3',
    connection: {
      filename: './data/comments.db' // use um caminho com diretório
    },
    migrations: {
      directory: './migrations'
    },
    useNullAsDefault: true,
  }
};